# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks for the use of a method, the result of which
      # would be a literal, like an empty array, hash or string.
      class EmptyLiteral < Cop
        include FrozenStringLiteralHelp

        ARR_MSG = 'Use array literal `[]` instead of `Array.new`.'.freeze
        HASH_MSG = 'Use hash literal `{}` instead of `Hash.new`.'.freeze
        STR_MSG = 'Use string literal `%s` instead of `String.new`.'.freeze

        def_node_matcher :array_node, '(send (const nil :Array) :new)'
        def_node_matcher :hash_node, '(send (const nil :Hash) :new)'
        def_node_matcher :str_node, '(send (const nil :String) :new)'

        def on_send(node)
          array_node(node) { add_offense(node, :expression, ARR_MSG) }

          hash_node(node) do
            # If Hash.new takes a block, it can't be changed to {}.
            return if node.parent && node.parent.block_type?

            add_offense(node, :expression, HASH_MSG)
          end

          str_node(node) do
            return if frozen_string_literals_enabled?

            add_offense(node, :expression,
                        format(STR_MSG, preferred_string_literal))
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(replacement_range(node), correction(node))
          end
        end

        private

        def preferred_string_literal
          enforce_double_quotes? ? '""' : "''"
        end

        def enforce_double_quotes?
          string_literals_config['EnforcedStyle'] == 'double_quotes'
        end

        def string_literals_config
          config.for_cop('Style/StringLiterals')
        end

        def first_argument_unparenthesized?(node)
          return false unless node.parent && node.parent.send_type?

          _receiver, _method_name, *args = *node.parent
          node.object_id == args.first.object_id && !parentheses?(node.parent)
        end

        def replacement_range(node)
          if hash_node(node) &&
             first_argument_unparenthesized?(node)
            # `some_method {}` is not same as `some_method Hash.new`
            # because the braces are interpreted as a block. We will have
            # to rewrite the arguments to wrap them in parenthesis.
            _receiver, _method_name, *args = *node.parent

            Parser::Source::Range.new(node.parent.loc.expression,
                                      args[0].loc.expression.begin_pos - 1,
                                      args[-1].loc.expression.end_pos)
          else
            node.source_range
          end
        end

        def correction(node)
          if array_node(node)
            '[]'
          elsif str_node(node)
            preferred_string_literal
          elsif hash_node(node)
            if first_argument_unparenthesized?(node)
              # `some_method {}` is not same as `some_method Hash.new`
              # because the braces are interpreted as a block. We will have
              # to rewrite the arguments to wrap them in parenthesis.
              _receiver, _method_name, *args = *node.parent
              "(#{args[1..-1].map(&:source).unshift('{}').join(', ')})"
            else
              '{}'
            end
          end
        end
      end
    end
  end
end

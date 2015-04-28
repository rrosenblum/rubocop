# encoding: utf-8

module RuboCop
  module Cop
    module Performance
      # This cop is used to convert usages of `keys.each` to `each_key`.
      class EachKey < Cop
        MSG = 'Use `each_key` instead of `keys.each`.'

        def on_send(node)
          left, second_method = *node
          _receiver, first_method = *left

          return unless second_method == :each
          return unless first_method == :keys

          range = Parser::Source::Range.new(node.loc.expression.source_buffer,
                                            left.loc.selector.begin_pos,
                                            node.loc.selector.end_pos)

          add_offense(node, range)
        end

        def autocorrect(node)
          left, = *node

          range = Parser::Source::Range.new(node.loc.expression.source_buffer,
                                            left.loc.selector.begin_pos,
                                            node.loc.selector.end_pos)

          lambda do |corrector|
            corrector.replace(range, 'each_key')
          end
        end
      end
    end
  end
end

# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # Checks for `if` statements that do not have an `else` statement.
      class MissingElse < Cop
        include OnNormalIfUnless

        MSG = '`if` condition requires an `else`-clause.'
        MSG_NIL = '`if` condition requires an `else`-clause with `nil` in it.'
        MSG_EMPTY = '`if` condition requires an empty `else`-clause.'

        def on_normal_if_unless(node)
          unless_else_cop = config.for_cop('Style/UnlessElse')
          unless_else_enabled = unless_else_cop['Enabled'] if unless_else_cop
          return if unless_else_enabled &&
                    node.loc.keyword &&
                    node.loc.keyword.is?('unless')
          check(node, if_else_clause(node))
        end

        def on_case(node)
          check(node, case_else_clause(node))
        end

        private

        def check(node, _else_clause)
          return if node.loc.else
          empty_else = config.for_cop('Style/EmptyElse')
          if empty_else && empty_else['Enabled']
            case empty_else['EnforcedStyle']
            when 'empty'
              add_offense(node, node.location, MSG_NIL)
            when 'nil'
              add_offense(node, node.location, MSG_EMPTY)
            end
          end
          add_offense(node, node.location, MSG)
        end
      end
    end
  end
end

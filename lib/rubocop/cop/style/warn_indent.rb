# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks whether the magic comment `warn_indent` is set or not.
      class WarnIndent < Cop
        MSG = 'Missing warn indent comment.'.freeze
        MSG_UNNECESSARY = 'Unnecessary warn indent comment.'.freeze

        def investigate(processed_source)
          #return if processed_source.tokens.empty?
        end
      end
    end
  end
end

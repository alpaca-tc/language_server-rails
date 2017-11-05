# frozen_string_literal: true

require 'thread'

module LanguageServerRails
  module Utils
    # rubocop:disable Security/Eval
    def self.safe_eval(string)
      result = nil

      thread = Thread.start do
        $SAFE = 1
        result = eval(string)
      end

      thread.join

      result
    end
    # rubocop:enable Security/Eval
  end
end

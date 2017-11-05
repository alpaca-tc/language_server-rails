# frozen_string_literal: true

module LanguageServerRails
  class CodeObject
    attr_reader :string

    def initialize(string)
      @string = string
    end

    def lookup
      simple_string_lookup || class_or_method_lookup
    end

    private

    def simple_string_lookup
      object = SafeEvaluator.safe_eval(string)

      if object.respond_to?(:source_location)
        WrappedMethod.new(object)
      elsif !object.is_a?(Module)
        WrappedModule.new(object.class)
      end
    end

    def class_or_method_lookup
      WrappedModule.from_string(string) || WrappedMethod.from_string(string)
    end
  end
end

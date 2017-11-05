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
        Wrapped::WrappedMethod.new(object)
      elsif !object.is_a?(Module)
        Wrapped::WrappedModule.new(object.class)
      end
    end

    def class_or_method_lookup
      Wrapped::WrappedModule.from_string(string) || Wrapped::WrappedMethod.from_string(string)
    end
  end
end

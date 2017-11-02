# frozen_string_literal: true

module LanguageServerRails
  class Method
    def initialize(module_or_class)
      @module_or_class = module_or_class
    end

    def definition_source_location
      found_method = (method_instances + instance_method_instances).first
      found_method.source_location
    end

    private

    def instance_method_instances
      @instance_method_instances ||= @module_or_class.instance_methods(false).map do |method_name|
        @module_or_class.instance_method(method_name)
      end
    end

    def method_instances
      @method_instances ||= @module_or_class.methods(false).map do |method_name|
        @module_or_class.method(method_name)
      end
    end
    # private
    #
    # def
  end
end

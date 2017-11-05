# frozen_string_literal: true

module LanguageServerRails
  class WrappedMethod
    class << self
      def from_string(string, current_binding = TOPLEVEL_BINDING)
        return if string.nil? || string.empty?

        if /(?<context>.+)\#(?<method_name>\S+)\Z/.match(string)
          object = Utils.safe_eval(Regexp.last_match[:context], current_binding)
          from_class(object, Regexp.last_match[:method_name])
        elsif /(?<context>.+)(\[\])\Z/.match(string)
          object = Utils.safe_eval(Regexp.last_match[:context], current_binding)
          from_object(object, :[])
        elsif /(?<context>.+)(?:\.|::)(?<method_name>\S+)\Z/.match(string)
          object = Utils.safe_eval(Regexp.last_match[:context], current_binding)
          from_object(object, Regexp.last_match[:method_name])
        else
          from_class_or_object(current_binding.eval('self'), string)
        end
      end

      private

      def from_class_or_object(object, string)
        from_class(object, string) || from_object(object, string)
      end

      def from_object(object, string)
        new(lookup_method_via_binding(object, string, :method))
      rescue
        nil
      end

      def from_class(klass, name)
        new(lookup_method_via_binding(klass, name, :instance_method))
      rescue
        nil
      end

      def lookup_method_via_binding(object, method_name, method_type)
        receiver = object.is_a?(::Module) ? ::Module : ::Kernel

        unbound_method = receiver.instance_method(method_type)
        unbound_method.bind(object).call(method_name)
      end
    end

    def initialize(wrapped)
      @wrapped = wrapped
    end

    # def definition_source_location
    #   found_method = (method_instances + instance_method_instances).first
    #   found_method.source_location
    # end
    #
    # private
    #
    # def instance_method_instances
    #   @instance_method_instances ||= @module_or_class.instance_methods(false).map do |method_name|
    #     @module_or_class.instance_method(method_name)
    #   end
    # end
    #
    # def method_instances
    #   @method_instances ||= @module_or_class.methods(false).map do |method_name|
    #     @module_or_class.method(method_name)
    #   end
    # end
    # # private
    # #
    # # def
  end
end

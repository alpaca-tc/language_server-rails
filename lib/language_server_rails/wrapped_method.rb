# frozen_string_literal: true

module LanguageServerRails
  class WrappedMethod
    METHOD_DETECTORS = {
      :[] => /(.+)(\[\])\Z/,
      method: /(.+)(?:\.|::)(\S+)\Z/,
      instance_method: /(.+)\#(\S+)\Z/
    }.freeze

    class << self
      def from_string(string, current_binding = TOPLEVEL_BINDING)
        return if string.nil? || string.empty?

        if METHOD_DETECTORS[:instance_method].match(string)
          context = Regexp.last_match(1)
          method_name = Regexp.last_match(2)
          object = Utils.safe_eval(context, current_binding)

          from_class(object, method_name, current_binding)
        elsif METHOD_DETECTORS[:[]].match(string)
          context = Regexp.last_match(1)
          method_name = Regexp.last_match(2)
          object = Utils.safe_eval(context, current_binding)

          from_object(object, method_name, current_binding)
        elsif METHOD_DETECTORS[:method].match(string)
          context = Regexp.last_match(1)
          method_name = Regexp.last_match(2)
          object = Utils.safe_eval(context, current_binding)

          from_object(object, method_name, current_binding)
        else
          from_class(current_binding.eval('self'), string, current_binding) || from_object(current_binding.eval('self'), string, current_binding)
        end
      end

      private

      def from_object(object, string, _current_binding = TOPLEVEL_BINDING)
        new(lookup_method_via_binding(object, string, :method))
      rescue
        nil
      end

      def from_class(klass, name, _current_binding = TOPLEVEL_BINDING)
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

    def initialize(module_or_class)
      @module_or_class = module_or_class
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

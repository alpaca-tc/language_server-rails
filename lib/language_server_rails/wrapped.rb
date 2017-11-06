# frozen_string_literal: true

module LanguageServerRails
  class Wrapped
    autoload :WrappedMethod, 'language_server_rails/wrapped/wrapped_method'
    autoload :WrappedModule, 'language_server_rails/wrapped/wrapped_module'

    attr_reader :wrapped

    def initialize(wrapped)
      @wrapped = wrapped
    end
  end
end

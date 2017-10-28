# frozen_string_literal: true

module LanguageServerRails
  module Service
    autoload :BaseService, 'language_server_rails/service/base_service'
    autoload :InitializeService, 'language_server_rails/service/initialize_service'
    autoload :ValidationService, 'language_server_rails/service/validation_service'
    autoload :HoverService, 'language_server_rails/service/hover_service'
  end
end

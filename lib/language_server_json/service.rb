module LanguageServerJson
  module Service
    autoload :BaseService, 'language_server_json/service/base_service'
    autoload :InitializeService, 'language_server_json/service/initialize_service'
    autoload :ValidationService, 'language_server_json/service/validation_service'
    autoload :HoverService, 'language_server_json/service/hover_service'
  end
end

# frozen_string_literal: true

require 'language_server'
require 'language_server_rails/version'

module LanguageServerRails
  autoload :Application, 'language_server_rails/application'
  autoload :Service, 'language_server_rails/service'
  autoload :Content, 'language_server_rails/content'
  autoload :ContentContext, 'language_server_rails/content_context'
end

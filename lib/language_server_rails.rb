# frozen_string_literal: true

require 'language_server'
require 'language_server_rails/version'

module LanguageServerRails
  autoload :Application, 'language_server_rails/application'
  autoload :Service, 'language_server_rails/service'
  autoload :Content, 'language_server_rails/content'
  autoload :Client, 'language_server_rails/client'
  autoload :Configuration, 'language_server_rails/configuration'
  autoload :ContentContext, 'language_server_rails/content_context'
  autoload :Project, 'language_server_rails/project'
  autoload :BackgroundServer, 'language_server_rails/background_server'
  autoload :Path, 'language_server_rails/path'
  autoload :Server, 'language_server_rails/server'
end

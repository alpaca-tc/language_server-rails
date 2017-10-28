# frozen_string_literal: true

require 'language_server'
require 'language_server_rails/version'

module LanguageServerRails
  autoload :Application, 'language_server_rails/application'
  autoload :Service, 'language_server_rails/service'
end

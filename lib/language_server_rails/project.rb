# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'pathname'

module LanguageServerRails
  class Project
    attr_reader :project_root, :configuration

    def initialize(project_root)
      @project_root = Pathname.new(project_root)
      @configuration = Configuration.new(project_root)
    end

    def client
      @client ||= Client.new(self)
    end

    def background_server
      @background_server ||= BackgroundServer.new(self)
    end

    def plain_ruby?
      true
    end

    def rails?
      File.exist?(project_root.join('config.ru')) && File.exist?(project_root.join('config/application.rb'))
    end
  end
end

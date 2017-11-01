# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'pathname'

module LanguageServerRails
  class Project
    attr_reader :project_root

    def initialize(project_root)
      @project_root = Pathname.new(project_root)
      @configuration = Configuration.new(project_root)
    end

    def background_server_source
      if rails?
        format(rails_project_command, server_program: server_program)
      elsif plain_ruby?
        format(ruby_project_command, server_program: server_program)
      end
    end

    private

    def server_program
      <<~PROGRAM
        require("#{File.expand_path('../server', __FILE__)}")

        LanguageServerRails::Server.new(
          socket_path: Pathname.new("#{@configuration.socket_path}"),
          pidfile_path: Pathname.new("#{@configuration.pidfile_path}")
        ).boot
      PROGRAM
    end

    def rails_project_command
      if File.exist?(project_root.join('bin', 'rails'))
        Shellwords.join([project_root.join('bin', 'rails').to_s, 'runner']) + "'%{server_program}'"
      else
        Shellwords.join(%w[bundle exec rails runner]) + ' %{server_program}'
      end
    end

    def ruby_project_command
      %{ruby -e '%{server_program}'}
    end

    def plain_ruby?
      true
    end

    def rails?
      File.exist?(project_root.join('config.ru')) && File.exist?(project_root.join('config/application.rb'))
    end
  end
end

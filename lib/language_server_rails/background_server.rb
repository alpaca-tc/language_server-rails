# frozen_string_literal: true

require 'json'
require 'socket'

module LanguageServerRails
  class BackgroundServer
    STOP_TIMEOUT = 2 # seconds

    def initialize(project)
      @project = project
    end

    def server_running?
      pidfile = @project.configuration.pidfile_path.open('r+')
      !pidfile.flock(File::LOCK_EX | File::LOCK_NB)
    rescue Errno::ENOENT
      false
    ensure
      return unless pidfile

      pidfile.flock(File::LOCK_UN)
      pidfile.close
    end

    def boot_server
      return if server_running?

      Dir.chdir(@project.project_root) do
        spawn(background_server_command)
      end
    end

    def stop
      return unless server_running?

      timeout = Time.now + STOP_TIMEOUT
      kill('TERM')
      sleep(0.1) while server_running? && Time.now < timeout

      kill('KILL') if server_running?
    end

    private

    def pid
      suppress(Errno::ENOENT) do
        @project.configuration.pidfile_path.read.to_i if @project.configuration.pidfile_path.exist?
      end
    end

    def kill(sig)
      suppress(Errno::ENOENT) do
        Process.kill(sig, pid) if pid
      end
    end

    def background_server_command
      if @project.rails?
        format(rails_project_command, server_program: server_program)
      elsif @project.plain_ruby?
        format(ruby_project_command, server_program: server_program)
      end
    end

    def server_program
      <<~PROGRAM
        require("#{File.expand_path('../server', __FILE__)}")

        LanguageServerRails::Server.new(
          socket_path: Pathname.new("#{@project.configuration.socket_path}"),
          pidfile_path: Pathname.new("#{@project.configuration.pidfile_path}")
        ).boot
      PROGRAM
    end

    def rails_project_command
      if File.exist?(@project.project_root.join('bin', 'rails'))
        Shellwords.join([@project.project_root.join('bin', 'rails').to_s, 'runner']) + "'%<server_program>s'"
      else
        Shellwords.join(%w[bundle exec rails runner]) + ' %<server_program>s'
      end
    end

    def ruby_project_command
      %(ruby -e '%<server_program>s')
    end
  end
end

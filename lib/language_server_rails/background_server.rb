# frozen_string_literal: true

require 'json'
require 'socket'

module LanguageServerRails
  class BackgroundServer
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

    private

    def stop_server
      server.close

      @server = nil
      @warmed_up = nil

      stop
    end

    def stop
      return unless server_running?

      timeout = Time.now + STOP_TIMEOUT
      kill('TERM')
      sleep(0.1) while server_running? && Time.now < timeout

      kill 'KILL' if server_running?
    end

    def kill(sig)
      pid = self.pid
      Process.kill(sig, pid) if pid
    rescue Errno::ESRCH
      # already dead
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
        Shellwords.join([@project.project_root.join('bin', 'rails').to_s, 'runner']) + "'%{server_program}'"
      else
        Shellwords.join(%w[bundle exec rails runner]) + ' %{server_program}'
      end
    end

    def ruby_project_command
      %{ruby -e '%{server_program}'}
    end
  end
end

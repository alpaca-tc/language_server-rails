# frozen_string_literal: true

require 'socket'

module LanguageServerRails
  class Client
    TIMEOUT = 1
    STOP_TIMEOUT = 2 # seconds

    def initialize(project)
      @project = project
      @background_server = @project.background_server
    end

    def run(id:, command:, script: '')
      unless @background_server.server_running?
        @background_server.boot_server
        return false
      end

      socket = client
      send_json(socket, id: id, command: command, script: script)
      receive_json(socket)
    rescue Errno::ECONNRESET
      exit 1
    ensure
      socket&.close
      @client = nil
    end

    private

    def client
      @client ||= UNIXSocket.open(@project.configuration.socket_path.to_s)
    end

    def send_json(socket, data)
      data = JSON.dump(data)
      socket.puts(data.bytesize)
      socket.write(data)
    end

    def receive_json(socket)
      JSON.load(socket.read(socket.gets.to_i))
    end
  end
end

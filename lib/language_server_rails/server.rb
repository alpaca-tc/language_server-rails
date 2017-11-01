# frozen_string_literal: true

require 'pathname'
require 'tempfile'
require 'socket'
require 'logger'
require 'json'

module LanguageServerRails
  class Server
    def initialize(socket_path:, pidfile_path:)
      @socket_path = socket_path
      @pidfile_path = pidfile_path
      @pidfile = pidfile_path.open('a')
    end

    def boot
      write_pid_file
      set_exit_hook
      start_server
    end

    private

    def debug(message)
      logger.debug("[server] #{message}")
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def start_server
      debug('boot server')
      server = UNIXServer.open(@socket_path.to_s)

      loop do
        serve(server.accept)
      end
    end

    def serve(socket)
      request = JSON.parse(socket.read(socket.gets.to_i))
      debug("serve socket #{request}")
      id, command, script = request.values_at('id', 'command', 'script')

      case command
      when 'eval'
        send_json(
          socket,
          id: id,
          status: 'success',
          data: safe_eval(script)
        )
      else
        socket.close
      end
    rescue SocketError => error
      raise error unless socket.eof?
    rescue => error
      socket.close
      puts error
    end

    def send_json(client, data)
      debug("response #{data}")

      data = JSON.dump(data)
      client.puts(data.bytesize)
      client.write(data)
    end

    # rubocop:disable Security/Eval
    def safe_eval(string)
      result = nil

      thread = Thread.start do
        $SAFE = 1
        result = eval(string)
      end

      thread.join

      result
    end
    # rubocop:enable Security/Eval

    def set_exit_hook
      at_exit { shutdown }
    end

    def shutdown
      [@socket_path, @pidfile_path].each do |path|
        next unless File.exist?(path)

        begin
          path.unlink
        rescue
          nil
        end
      end
    end

    def write_pid_file
      if @pidfile.flock(File::LOCK_EX | File::LOCK_NB)
        @pidfile.truncate(0)
        @pidfile.write("#{Process.pid}\n")
        @pidfile.fsync
      else
        exit 1
      end
    end
  end
end

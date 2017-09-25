# frozen_string_literal: true

require 'rack'
require 'rack/utils'
require 'rack/content_length'
require 'rack/handler/cgi'

require 'language_server/message_buffer'

module LanguageServer
  # TODO: Rename name. StdHandler is not easy to understand
  class StdHandler < Rack::Handler::CGI
    def self.serve(app)
      buffer = MessageBuffer.new
      next_message_length = nil

      next_buffer = ''.dup

      while char = STDIN.getc
        buffer.append(char)
        next_buffer << char

        unless next_message_length
          headers = buffer.try_read_headers
          next unless headers
          raise 'content-length not found' unless headers[Rack::CONTENT_LENGTH]
          next_message_length = headers[Rack::CONTENT_LENGTH].to_i
        end

        if content = buffer.try_read_content(next_message_length)
          require 'pry-remote'
          binding.remote_pry;
          next_message_length = nil
          process(app, content)
        end
      end
    end

    def self.process(app, content)
      env = ENV.to_hash
      env.delete 'HTTP_CONTENT_LENGTH'

      env[Rack::SCRIPT_NAME] = '' if env[Rack::SCRIPT_NAME] == '/'

      env.update(
        Rack::RACK_VERSION      => Rack::VERSION,
        Rack::RACK_INPUT        => StringIO.new(content),
        Rack::RACK_ERRORS       => $stderr,
        Rack::RACK_MULTITHREAD  => false,
        Rack::RACK_MULTIPROCESS => true,
        Rack::RACK_RUNONCE      => true,
        Rack::RACK_URL_SCHEME   => %w[yes on 1].include?(ENV[Rack::HTTPS]) ? 'https' : 'http'
      )

      # http://www.jsonrpc.org/historical/json-rpc-over-http.html
      env.update(
        Rack::CONTENT_TYPE      => 'application/json-rpc',
        'Accept'                => 'application/json-rpc',
        Rack::CONTENT_LENGTH    => content.bytesize
      )

      env[Rack::QUERY_STRING] ||= ''
      env[Rack::HTTP_VERSION] ||= env[Rack::SERVER_PROTOCOL]
      env[Rack::REQUEST_PATH] ||= '/'

      status, headers, body = app.call(env)

      begin
        send_headers status, headers
        send_body body
      ensure
        body.close if body.respond_to? :close
      end
    end
  end
end

# frozen_string_literal: true

require 'rack'
require 'rack/request'
require 'language_server-protocol'

module LanguageServer
  class JsonRPCMiddleware
    REQUEST_BODY = 'language_server.request_body'

    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      json_body = {}

      begin
        json_body = parse_body(request)
      rescue JSONError => error
        return build_error(status: 500, id: body[:id], code: -32_700, message: error.to_s)
      end

      begin
        _status, headers, body = @app.call(env)
        [200, headers, body]
      rescue MethodNotFound => error
        return build_error(
          status: 404,
          id: json_body[:id],
          code: LanguageServer::Protocol::Constant::ErrorCodes::METHOD_NOT_FOUND,
          message: error.to_s
        )
        # rescue InvalidRequest
        #   return [400, {}, { code: '-32600' }]
        # rescue InvalidParams
        #   return [500, {}, { code: '-32602' }]
        # rescue
        #   return [500, {}, { code: '-32603' }]
        # rescue Exception => error
        #   return [500, {}, { code: '-32099' }]
      end
    end

    private

    def build_error(status:, id:, code:, message:)
      # FIXME: fixes response
      return [500, {}, [{ error: { code: code, message: message } }.to_json]] unless id

      result = LanguageServer::Protocol::Interface::ResponseMessage.new(
        jsonrpc: '2.0',
        id: id,
        error: {
          code: code,
          message: message
        }
      )

      [status, {}, [result.to_json]]
    end

    def parse_body(request)
      rack_input = request.get_header(Rack::RACK_INPUT)
      json = JSON.parse(rack_input.read, symbolize_names: true)
      request.set_header(REQUEST_BODY, json)
    ensure
      rack_input.rewind
    end
  end
end

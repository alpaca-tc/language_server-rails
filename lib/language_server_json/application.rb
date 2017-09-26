# frozen_string_literal: true

require 'rack'
require 'rack/request'

module LanguageServerJson
  class Application
    # Rack interface
    def self.call(env)
      request = Rack::Request.new(env)
      params = request.get_header(LanguageServer::JsonRPCMiddleware::REQUEST_BODY)

      body = new(params).process
      [200, {}, [body]]
    end

    def initialize(params = {})
      @params = params
    end

    def process
      result = case @params[:method]
                 when 'initialize'
                   Service::InitializeService.new(@params).do_initialize
                 when 'textDocument/hover'
                   Service::HoverService.new(@params).do_hover
                 when 'exit'
                   exit
                 when 'textDocument/didChange', 'textDocument/didSave'
                   raise LanguageServer::MethodNotFound, "not supported method given #{@params[:method]}"
                 else
                   raise LanguageServer::MethodNotFound, "not supported method given #{@params[:method]}"
                 end

      response_message = LanguageServer::Protocol::Interface::ResponseMessage.new(
        id: @params[:id],
        result: result
      )

      response_message.attributes.merge(jsonrpc: "2.0").to_json.tap do |body|
        LanguageServer.logger.debug("out: #{body}")
      end
    rescue => error
      LanguageServer.logger.debug("error!!!: #{error}")
      raise
    end
  end
end

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
      LanguageServer.logger.debug("in: #{@params}")

      response = case @params[:method]
                 when 'initialize'
                   Service::InitializeService.new(@params).do_initialize
                 else
                   raise NotImplementedError, "not supported method given #{@params[:method]}"
                 end

      LanguageServer.logger.debug("out: #{response.to_json}")
      response.to_json
    end
  end
end

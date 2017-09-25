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
      require 'pry'
      binding.remote_pry
      # case @params[:method]
      # when 'initialize'
      #   InitializeService.new()
      # else
      # end
    end
  end
end

# frozen_string_literal: true

require 'rack'
require 'rack/request'
require 'uri'

module LanguageServerRails
  class Application
    # Rack interface
    def self.call(env)
      request = Rack::Request.new(env)
      params = request.get_header(LanguageServer::JsonRPCMiddleware::REQUEST_BODY)

      body = new(params).process
      [200, {}, [body]]
    end

    def self.project(project_root)
      @project ||= Project.new(LanguageServerRails::Content.new(project_root).path)
    end

    def initialize(params = {})
      LanguageServerRails.logger.debug("[client] #{params}")
      @params = params
    end

    def process
      project = self.class.project(project_root)

      result = case @params[:method]
               when 'initialize'
                 Service::InitializeService.new(project, @params).do_initialize
               when 'textDocument/hover'
                 Service::HoverService.new(project, @params).do_hover
               when 'textDocument/definition'
                 Service::DefinitionService.new(project, @params).do_definition
               when 'exit'
                 LanguageServerRails.logger.debug('[application] exit')
                 exit
               when 'textDocument/didChange', 'textDocument/didSave'
                 raise LanguageServer::MethodNotFound, "not supported method given #{@params[:method]}"
               else
                 raise LanguageServer::MethodNotFound, "not supported method given #{@params[:method]}"
               end

      response_message = LanguageServer::Protocol::Interface::ResponseMessage.new(
        jsonrpc: '2.0',
        id: @params[:id],
        result: result
      )

      response_message.attributes.merge(jsonrpc: '2.0').to_json.tap do |body|
        LanguageServer.logger.debug("out: #{body}")
      end
    rescue => error
      LanguageServer.logger.debug("error!!!: #{error}")
      raise
    end

    private

    def project_root
      @params.dig(:params, :rootUri)
    end
  end
end

# frozen_string_literal: true

require 'json'
require 'logger'
require 'language_server/exceptions'

module LanguageServer
  autoload :MessageBuffer, 'language_server/message_buffer'
  autoload :JsonRPCMiddleware, 'language_server/json_rpc_middleware'
  autoload :StdHandler, 'language_server/std_handler'

  def self.logger
    @logger ||= Logger.new('/tmp/sample')
  end

  def self.logger=(logger)
    @logger = logger
  end
end

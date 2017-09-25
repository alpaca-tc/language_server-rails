# frozen_string_literal: true

require 'json'
require 'language_server/exceptions'

module LanguageServer
  autoload :MessageBuffer, 'language_server/message_buffer'
  autoload :JsonRPCMiddleware, 'language_server/json_rpc_middleware'
  autoload :StdHandler, 'language_server/std_handler'
end

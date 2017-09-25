# frozen_string_literal: true

module LanguageServer
  class LanguageServerError < StandardError; end
  class InvalidRequest < LanguageServerError; end
  class MethodNotFound < LanguageServerError; end
  class InvalidParams < LanguageServerError; end
end

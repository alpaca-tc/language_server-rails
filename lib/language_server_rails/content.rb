# frozen_string_literal: true

module LanguageServerRails
  class Content
    def initialize(raw_uri)
      @raw_uri = raw_uri
      @uri = URI(raw_uri)
    end

    def exists?
      case @uri.scheme
      when 'file'
        File.exist?(@uri.path)
      else
        raise NotImplementedError, 'not implemented yet'
      end
    end

    def body
      @body ||= case @uri.scheme
                when 'file'
                  File.read(@uri.path)
                else
                  raise NotImplementedError, 'not implemented yet'
                end
    end
  end
end
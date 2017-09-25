# frozen_string_literal: true

require 'rack'
require 'rack/utils'

module LanguageServer
  class MessageBuffer
    DELIMITER = "\r\n\r\n"

    attr_reader :buffer, :index

    def initialize(encoding = Encoding::UTF_8)
      @buffer = ''.dup
      @index = 0
      @encoding = encoding
    end

    def append(chunk)
      chunk = chunk.force_encoding(@encoding)

      @buffer += chunk
      @index  += chunk.bytesize
    end

    def try_read_headers
      current = 0
      while current + 3 < @buffer.bytesize && @buffer.byteslice(current, current + 3) != DELIMITER
        current += 1
      end

      # No header / body separator found (e.g CRLFCRLF)
      return if current + 3 >= @index

      headers_section = @buffer.byteslice(0, current).force_encoding(Encoding::ASCII)

      next_start = current + 4

      @buffer = @buffer.byteslice(next_start, @buffer.bytesize)
      @index -= next_start

      parse_header_hash_from_string(headers_section)
    end

    def try_read_content(length)
      return if @index < length

      result = @buffer.byteslice(0, @buffer.bytesize).force_encoding(@encoding)
      next_start = length
      @buffer = @buffer.byteslice(next_start, @buffer.bytesize)
      @index -= next_start

      result
    end

    private

    def parse_header_hash_from_string(headers_section)
      headers = headers_section.split(DELIMITER)

      headers.each_with_object(Rack::Utils::HeaderHash.new) do |header, hash|
        key, value = header.split(':')
        raise 'Message header must separate key and value using :' if !key && !value

        hash[key] = value.strip
      end
    end
  end
end

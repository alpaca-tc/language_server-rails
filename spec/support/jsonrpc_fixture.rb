# frozen_string_literal: true

require 'pathname'

Module.new do
  def jsonrpc_fixture(path)
    jsonrpc_path = jsonrpc_fixture_path.join(path)
    JSON.parse(File.read(jsonrpc_path))
  end

  def jsonrpc_request_fixture(path)
    json = jsonrpc_fixture(path)
    build_request_from_json(json)
  end

  private

  def build_request_from_json(json)
    body_section = json.to_json

    headers = {
      'Content-Length' => body_section.bytesize
    }

    headers_section = headers.map { |key, value| [key, ':', value, "\r\n"] }.join

    [headers_section, "\r\n", body_section].join
  end

  def jsonrpc_fixture_path
    Pathname.new(File.expand_path('../../fixtures/jsonrpc', __FILE__))
  end

  RSpec.configure do |config|
    config.include(self)
  end
end

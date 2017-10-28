# frozen_string_literal: true

RSpec.describe LanguageServerRails::Service::HoverService do
  describe do
    shared_context 'jsonrpc fixture' do |path, prefix: ''|
      fixture_path = File.expand_path('../../../fixtures/jsonrpc', __FILE__)

      let(:"#{prefix}params") do
        deep_replace(public_send("#{prefix}jsonrpc_content"), '$FILE', public_send("#{prefix}file_path"))
      end

      let(:"#{prefix}jsonrpc_path") do
        File.join(fixture_path, path, 'jsonrpc.json')
      end

      let(:"#{prefix}jsonrpc_content") do
        JSON.parse(File.read(public_send("#{prefix}jsonrpc_path")), symbolize_names: true)
      end

      let(:"#{prefix}file_path") do
        'file://' + File.join(fixture_path, path, 'file.rb')
      end

      let(:"#{prefix}file_content") do
        File.read(public_send("#{prefix}file_path"))
      end

      def deep_replace(hash, target, string)
        new_hash = {}

        hash.each do |key, value|
          new_hash[key] = if value.is_a?(Hash)
                            deep_replace(value, target, string)
                          elsif value == target
                            string
                          else
                            value
                          end
        end

        new_hash
      end
    end

    describe '#do_hover' do
      include_context 'jsonrpc fixture', 'hover/single_file'

      subject { described_class.new(params).do_hover }

      it do |_example|
        subject
      end

      # let(:params) do
      #   {
      #     jsonrpc: '2.0',
      #     method: 'textDocument/hover',
      #     id: 1,
      #     params: {
      #       textDocument: {
      #         uri: '$FILE'
      #       },
      #       position: {
      #         line: 1,
      #         character: 3
      #       }
      #     }
      #   }
      # end
    end
  end
end

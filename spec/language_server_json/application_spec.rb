# frozen_string_literal: true

RSpec.describe LanguageServerJson::Application do
  let(:env) do
    {
      LanguageServer::JsonRPCMiddleware::REQUEST_BODY => json
    }
  end

  let(:json) do
    {}
  end

  describe 'ClassMethods' do
    describe '.call' do
      subject do
        -> { described_class.call(env) }
      end

      it 'initializes application and call process' do
        allow_any_instance_of(described_class).to receive(:process).once
        subject.call
      end
    end
  end

  describe 'InstanceMethods' do
    let(:instance) { described_class.new(params) }

    describe '#process' do
      subject { instance.process }

      context 'initialize' do
        let(:params) { jsonrpc_fixture('initialize/jsonrpc.json') }

        it 'returns response' do
          is_expected.to be_a(String)
        end
      end
    end
  end
end

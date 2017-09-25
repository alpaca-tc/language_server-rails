RSpec.describe LanguageServer::JsonRPCMiddleware do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(rack_application) }

    let(:rack_application) do
      ->(_env) { [200, {}, []] }
    end

    let(:env) do
      {
        Rack::RACK_INPUT => StringIO.new(body)
      }
    end

    describe '#call' do
      subject do
        -> { instance.call(env) }
      end

      shared_examples_for 'a parsed jsonrpc body' do
        it 'parses body' do
          is_expected.to change {
            env[described_class::REQUEST_BODY]
          }.from(nil)
        end
      end

      context 'given valid body' do
        let(:body) { jsonrpc_fixture('initialize/jsonrpc.json').to_json }
        it_behaves_like 'a parsed jsonrpc body'
      end
    end
  end
end

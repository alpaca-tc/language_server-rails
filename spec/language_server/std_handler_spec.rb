require 'language_server/std_handler'

RSpec.describe LanguageServer::StdHandler do
  describe 'ClassMethods' do
    let(:rack_application) do
      ->(_env) { [200, { 'Content-Length' => '2' }, ['{}']] }
    end

    describe '.run' do
      subject do
        -> { described_class.run(rack_application) }
      end

      it 'calls serve' do
        expect(described_class).to receive(:serve).with(rack_application).once
        subject.call
      end
    end

    describe '.serve' do
      let(:jsonrpc_request) { jsonrpc_request_fixture('initialize/jsonrpc.json') }

      before do
        stdin = StringIO.new(jsonrpc_request)
        stub_const("#{described_class}::STDIN", stdin)
      end
    end

    describe '.process' do
      subject do
        -> { described_class.process(rack_application, content) }
      end

      let(:content) { '' }

      it 'calls rack application' do
        allow($stdout).to receive(:print) { nil } # Do not print anything in test environment
        expect(rack_application).to receive(:call).once.and_call_original
        subject.call
      end

      it 'writes response to stdout' do
        is_expected.to output("Status: 200\r\nContent-Length: 2\r\n\r\n{}").to_stdout
      end
    end
  end
end

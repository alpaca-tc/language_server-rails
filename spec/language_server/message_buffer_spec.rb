RSpec.describe LanguageServer::MessageBuffer do
  let(:instance) { described_class.new }
  let(:jsonrpc_request) { jsonrpc_request_fixture('initialize/jsonrpc.json') }

  context 'InstanceMethods' do
    describe '#append' do
      subject do
        -> { instance.append(jsonrpc_request) }
      end

      it 'appends given value to buffer' do
        is_expected.to change {
          [instance.buffer, instance.index]
        }.from(['', 0]).to([jsonrpc_request, jsonrpc_request.bytesize])
      end
    end

    describe '#try_read_headers' do
      subject do
        instance.try_read_headers
      end

      context 'headers is not found' do
        it { is_expected.to be_nil }
      end

      context 'headers is found' do
        before do
          instance.append("Content-Length: 0\r\n\r\n")
        end

        it { is_expected.to eq('Content-Length' => '0') }
      end
    end

    describe '#try_read_content' do
      subject do
        instance.try_read_content(length)
      end

      before do
        instance.append(buffer)
      end

      context 'content is not found' do
        let(:length) { 10 }
        let(:buffer) { '' }
        it { is_expected.to be_nil }
      end

      context 'headers is found' do
        let(:length) { 2 }
        let(:buffer) { '{}' }
        it { is_expected.to eq('{}') }
      end
    end
  end
end

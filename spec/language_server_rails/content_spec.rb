# frozen_string_literal: true

RSpec.describe LanguageServerRails::Content do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(uri) }
    let(:uri) { "file://#{jsonrpc_fixture_path.join('content.module.rb')}" }

    describe '#body' do
      subject { instance.body }
      it { is_expected.to be_present }
    end
  end
end

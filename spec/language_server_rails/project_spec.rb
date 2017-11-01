# frozen_string_literal: true

RSpec.describe LanguageServerRails::Project do
  let(:instance) { described_class.new(rails_root) }

  describe 'InstanceMethods' do
    describe '#background_server_source' do
      subject { instance.background_server_source }

      before do
        allow(instance).to receive(:rails?).and_return(rails?)
        allow(instance).to receive(:plain_ruby?).and_return(plain_ruby?)
      end

      let(:rails?) { false }
      let(:plain_ruby?) { false }

      context 'when backend server is rails' do
        let(:rails?) { true }
        it { is_expected.to include('rails runner') }
      end

      context 'when backend server is rails' do
        let(:plain_ruby?) { true }
        it { is_expected.to start_with('ruby -e') }
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe LanguageServerRails::CodeObject do
  let(:instance) { described_class.new(string) }

  describe 'InstanceMethods' do
    describe '#lookup' do
      subject { instance.lookup }

      context 'given instance method' do
        let(:string) { 'LanguageServerRails::CodeObject#lookup' }
        it { is_expected.to be_a(LanguageServerRails::Wrapped::WrappedMethod) }
      end

      context 'given module' do
        let(:string) { 'LanguageServerRails::CodeObject' }
        it { is_expected.to be_a(LanguageServerRails::Wrapped::WrappedModule) }
      end
    end
  end
end

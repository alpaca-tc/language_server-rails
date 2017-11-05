# frozen_string_literal: true

RSpec.describe LanguageServerRails::CodeObject do
  let(:instance) { described_class.new(string) }

  describe 'InstanceMethods' do
    describe '#lookup' do
      subject { instance.lookup }
      let(:string) { 'LanguageServerRails::CodeObject#lookup' }
      it { is_expected.to be_a(LanguageServerRails::Wrapped::WrappedMethod) }
      it { binding.pry; }
    end
  end
end

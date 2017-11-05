# frozen_string_literal: true

RSpec.describe LanguageServerRails::WrappedModule do
  describe 'ClassMethods' do
    describe '.from_string' do
      subject { described_class.from_string(string) }
      let(:string) { 'LanguageServerRails' }
      it { is_expected.to be_a(described_class) }
    end
  end

  describe 'InstanceMethods' do
    subject { described_class.new(wrapped_module) }

    context 'with non-module' do
      let(:wrapped_module) { 1 }
      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end

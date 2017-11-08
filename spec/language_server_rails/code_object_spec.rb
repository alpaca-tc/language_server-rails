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

      context 'given instance method' do
        let(:string) { 'LanguageServerRails::Service::DefinitionService#logger' }
        fit { binding.pry; is_expected.to be_a(LanguageServerRails::Wrapped::WrappedMethod) }
      end

      context 'given module' do
        let(:string) { 'LanguageServerRails::CodeObject' }
        it { is_expected.to be_a(LanguageServerRails::Wrapped::WrappedModule) }
      end

      context 'given Object.new' do
        let(:string) { 'Object.new' }
        it { is_expected.to be_a(LanguageServerRails::Wrapped::WrappedMethod) }
      end

      context 'given "string"' do
        let(:string) { '"string"' }
        it { is_expected.to be_nil }
      end

      context 'given unknown' do
        let(:string) { 'unknown' }
        it { is_expected.to be_nil }
      end
    end
  end
end

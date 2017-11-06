# frozen_string_literal: true

RSpec.describe LanguageServerRails::Wrapped::WrappedModule do
  describe 'ClassMethods' do
    describe '.from_string' do
      subject { described_class.from_string(string) }
      let(:string) { 'LanguageServerRails' }
      it { is_expected.to be_a(described_class) }
    end
  end

  describe 'InstanceMethods' do
    describe '#initialize' do
      subject { described_class.new(wrapped) }

      context 'with non-module' do
        let(:wrapped) { 1 }
        it { expect { subject }.to raise_error(ArgumentError) }
      end
    end

    describe '#source_location' do
      subject { instance.source_location }
      let(:instance) { described_class.new(described_class) }
      let(:file) { File.expand_path('../../../../lib/language_server_rails/wrapped/wrapped_module.rb', __FILE__) }
      let(:line) { 4 } # line of `class WrappedModule < Wrapped`
      let(:character) { 10 } # character of `WrappedModule < Wrapped`

      it 'returns source_location' do
        is_expected.to eq([file, line, character])
      end
    end
  end
end

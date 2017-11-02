# frozen_string_literal: true

RSpec.describe LanguageServerRails::Method do
  describe 'InstanceMethods' do
    describe '#definition_source_location' do
      subject { instance.definition_source_location }
      let(:instance) { described_class.new(class_or_module) }
      let(:class_or_module) { LanguageServerRails::Service::InitializeService }
      it { is_expected.to eq([]) }
    end
  end
end

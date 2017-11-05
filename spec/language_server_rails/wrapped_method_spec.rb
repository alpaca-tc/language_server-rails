# frozen_string_literal: true

RSpec.describe LanguageServerRails::WrappedMethod do
  describe 'ClassMethods' do
    describe '.from_string' do
      subject { described_class.from_string(string, current_binding) }
      let(:current_binding) { TOPLEVEL_BINDING }

      context 'given nil' do
        let(:string) { nil }
        it { is_expected.to be_nil }
      end

      context 'given list[]' do
        let(:current_binding) do
          list = []
          binding
        end

        let(:string) { 'list[]' }
        it { is_expected.to be_a(described_class) }
      end

      context 'given Object.constants' do
        let(:string) { 'Object.constants' }
        it { is_expected.to be_a(described_class) }
      end

      context 'given ::Object' do
        let(:string) { '::Object' }
        it { is_expected.to be_nil }
      end
    end
  end

  # describe 'InstanceMethods' do
  #   describe '#definition_source_location' do
  #     subject { instance.definition_source_location }
  #     let(:instance) { described_class.new(class_or_module) }
  #     let(:class_or_module) { LanguageServerRails::Service::InitializeService }
  #     let(:initialize_service_path) { File.expand_path('../../lib/language_server_rails/service/initialize_service.rb', __FILE__) }
  #
  #     it { is_expected.to eq([]) }
  #   end
  # end
end

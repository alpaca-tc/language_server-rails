# frozen_string_literal: true

RSpec.describe LanguageServerRails::Content do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(uri) }
    let(:uri) { "file://#{__FILE__}" }

    describe '#path' do
      subject { instance.path }
      it { is_expected.to eq(__FILE__) }
    end

    describe '#read' do
      subject { instance.read }
      it { is_expected.to eq(File.read(__FILE__)) }
    end
  end
end

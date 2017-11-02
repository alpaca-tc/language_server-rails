# frozen_string_literal: true

RSpec.describe LanguageServerRails::Content do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(uri) }
    let(:uri) { "file://#{__FILE__}" }

    describe '#read' do
      subject { instance.read }
      it { is_expected.to eq(File.read(__FILE__)) }
    end
  end
end

# frozen_string_literal: true

RSpec.describe LanguageServerRails::Project do
  let(:instance) { described_class.new(project_root) }
  let(:project_root) { __dir__ }

  describe '#background_server' do
    subject { instance.background_server }
    it { is_expected.to be_a(LanguageServerRails::BackgroundServer) }
  end

  describe '#plain_ruby?' do
    subject { instance.plain_ruby? }
    it { is_expected.to be true }
  end

  describe '#rails?' do
    subject { instance.rails? }

    context 'given ruby project' do
      let(:project_root) { __dir__ }
      it { is_expected.to be false }
    end

    context 'given rails project' do
      let(:project_root) { rails_root }
      it { is_expected.to be true }
    end
  end
end

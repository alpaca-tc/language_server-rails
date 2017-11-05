# frozen_string_literal: true

RSpec.describe LanguageServerRails::Project do
  let(:instance) { described_class.new(project_root) }
  let(:project_root) { __dir__ }

  describe '#client' do
    subject { instance.client }
    it { is_expected.to be_a(LanguageServerRails::Client) }
  end

  describe '#background_server' do
    subject { instance.background_server }
    it { is_expected.to be_a(LanguageServerRails::BackgroundServer) }
  end

  describe '#plain_ruby?' do
    subject { instance.plain_ruby? }
    it { is_expected.to be true }
  end

  describe '#gem?' do
    subject { instance.gem? }

    context 'given ruby project' do
      let(:project_root) { __dir__ }
      it { is_expected.to be false }
    end

    context 'given gem project' do
      let(:project_root) { Pathname.new(File.expand_path('../../../', __FILE__)) }
      it { is_expected.to be true }
    end
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

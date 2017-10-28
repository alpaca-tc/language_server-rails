# frozen_string_literal: true

RSpec.describe LanguageServerRails::ContentContext do
  let(:instance) { described_class.new(content, line, character) }
  let(:content) { LanguageServerRails::Content.new(uri) }
  let(:uri) { "file://#{fixture_path.join('content', 'module.rb')}" }
  let(:line) { 0 }
  let(:character) { 0 }

  describe '#cursor_text' do
    subject { instance.cursor_text }
    it { is_expected.to eq('module') }
  end
end

# frozen_string_literal: true

RSpec.describe LanguageServerRails::ContentContext do
  context 'InstanceMethods' do
    let(:instance) { described_class.new(content, line, character) }
    let(:content) { LanguageServerRails::Content.new(uri) }

    describe '#cursor_text' do
      subject { instance.cursor_text }

      shared_examples_for 'a cursor text' do |line:, character:, text:, focus: false|
        let(:line) { line }
        let(:character) { character }

        it(nil, focus: focus) { is_expected.to eq(text) }
      end

      context 'feed_manager.rb' do
        let(:uri) { "file://#{fixture_path.join('mastodon_samples', 'feed_manager.rb')}" }

        it_behaves_like 'a cursor text', line: 10, character: 2, text: 'REBLOG_FALLOFF'
        it_behaves_like 'a cursor text', line: 10, character: 17, text: '='
        it_behaves_like 'a cursor text', line: 10, character: 20, text: '40'
        it_behaves_like 'a cursor text', line: 12, character: 6, text: 'key'
        it_behaves_like 'a cursor text', line: 13, character: 39, text: 'subtype'
        it_behaves_like 'a cursor text', line: 22, character: 10, text: 'filter_from_mentions?'
        it_behaves_like 'a cursor text', line: 24, character: 6, text: 'false'
        it_behaves_like 'a cursor text', line: 25, character: 6, text: 'end'
        it_behaves_like 'a cursor text', line: 26, character: 2, text: 'end'
        it_behaves_like 'a cursor text', line: 31, character: 9, text: 'timeline_type'
        it_behaves_like 'a cursor text', line: 41, character: 14, text: 'Oj'
        it_behaves_like 'a cursor text', line: 41, character: 16, text: '.'
        it_behaves_like 'a cursor text', line: 41, character: 13, text: nil
        it_behaves_like 'a cursor text', line: 41, character: 12, text: '='
        it_behaves_like 'a cursor text', line: 42, character: 27, text: 'timeline:'
        it_behaves_like 'a cursor text', line: 51, character: 59, text: 'FeedManager::MAX_ITEMS'
        it_behaves_like 'a cursor text', line: 56, character: 78, text: 'with_scores'
        it_behaves_like 'a cursor text', line: 56, character: 91, text: 'true'
        it_behaves_like 'a cursor text', line: 67, character: 49, text: 'reblogged_id'
        it_behaves_like 'a cursor text', line: 72, character: 21, text: ':home'

        # TODO
        # it_behaves_like 'a cursor text', line: 77, character: 61, text: 'FeedManager::MAX_ITEMS', focus: true
      end

      # 特定のテストのために追記していくテンプレート
      context 'custom_template.rb' do
        let(:uri) { "file://#{fixture_path.join('mastodon_samples', 'custom_template.rb')}" }
        it_behaves_like 'a cursor text', line: 2, character: 0, text: 'for'

        # Heredoc not supported
        # it_behaves_like 'a cursor text', line: 6, character: 5, text: '<<~HEREDOC'
        # it_behaves_like 'a cursor text', line: 7, character: 0, text: 'hello', focus: true
        # it_behaves_like 'a cursor text', line: 10, character: 6, text: '<<-HEREDOC'
        # it_behaves_like 'a cursor text', line: 15, character: 0, text: 'hello', focus: true

        it_behaves_like 'a cursor text', line: 21, character: 2, text: 'puts'
        it_behaves_like 'a cursor text', line: 24, character: 8, text: 'b'
        it_behaves_like 'a cursor text', line: 25, character: 7, text: 'c'
      end
    end
  end
end

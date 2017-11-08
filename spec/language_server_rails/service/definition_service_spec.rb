# frozen_string_literal: true

RSpec.describe LanguageServerRails::Service::DefinitionService do
  describe do
    describe '#do_definition' do
      subject { instance.do_definition }
      let(:instance) { described_class.new(project, params) }

      let(:params) do
        {
          jsonrpc: '2.0',
          id: 33,
          method: 'textDocument/definition',
          params: {
            textDocument: {
              uri: uri
            },
            position: {
              line: cursor_line,
              character: cursor_character
            }
          }
        }
      end

      let(:uri) { "file://#{uri_file}" }
      let(:uri_file) { project_root.join('lib', 'gemspec_sample', 'for_definition_finder.rb') }
      let(:file_lines) { File.read(project_root.join('lib', 'gemspec_sample', 'for_definition_finder.rb')).split("\n") }
      let(:cursor_line) { file_lines.rindex { |line| /def please_find_me/.match?(line) } }
      let(:cursor_character) { file_lines[cursor_line].index('please_find_me') }
      let(:project) { LanguageServerRails::Project.new(project_root) }
      let(:project_root) { gemspec_sample_root }
      let(:lib_dir) { gemspec_sample_root.join('lib').to_s }

      before do
        $LOAD_PATH.unshift(lib_dir)
        load "#{lib_dir}/gemspec_sample.rb"
      end

      after do
        $LOAD_PATH.delete(lib_dir)
        Object.__send__(:remove_const, :GemspecSample)
      end

      context 'given method name' do
        it 'finds definition' do
          subject
          # is_expected.to eq(
          #   id: 1,
          #   status: 'success',
          #   data: GemspecSample::ForDefinitionFinder.instance_method(:please_find_me).source_location
          # )
        end
      end
    end
  end
end

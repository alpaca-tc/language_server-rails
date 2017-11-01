# frozen_string_literal: true

require 'fileutils'

RSpec.describe LanguageServerRails::BackgroundServer do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(project) }
    let(:project) { LanguageServerRails::Project.new(__dir__) }

    after do
      instance.stop
    end

    describe '#boot_server' do
      subject { instance.boot_server }

      before do
        allow(project).to receive(:rails?).and_return(rails?)
        allow(project).to receive(:plain_ruby?).and_return(plain_ruby?)
      end

      let(:rails?) { false }
      let(:plain_ruby?) { false }

      context 'when backend server is rails' do
        let(:rails?) { true }

        it 'spawn rails runner' do
          expect(instance).to receive(:spawn) do |command|
            expect(command).to start_with('bundle exec rails runner')
          end

          subject
        end
      end

      context 'when backend server is rails' do
        let(:plain_ruby?) { true }

        it 'spawn rails runner' do
          expect(instance).to receive(:spawn) do |command|
            expect(command).to start_with('ruby -e')
          end

          subject
        end
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe LanguageServerRails::Utils do
  describe 'ClassMethods' do
    describe '.safe_eval' do
      subject do
        -> { described_class.safe_eval(string) }
      end

      context 'given safe string' do
        let(:string) { 'Object.constants' }

        it 'evaluates the string' do
          expect(subject.call).to eq(Object.constants)
        end
      end

      context 'given dangerous string' do
        let(:string) { "FileUtils.rm('#{Tempfile.new.path}')" }

        it 'prevent to evaluate the string' do
          is_expected.to raise_error(SecurityError)
        end
      end
    end
  end
end

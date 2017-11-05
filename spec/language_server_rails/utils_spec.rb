# frozen_string_literal: true

RSpec.describe LanguageServerRails::Utils do
  describe 'ClassMethods' do
    describe '.safe_eval' do
      subject do
        described_class.safe_eval(string, binding)
      end

      let(:binding) { TOPLEVEL_BINDING }

      context 'given safe string' do
        let(:string) { 'Object.constants' }

        it 'evaluates the string' do
          is_expected.to eq(Object.constants)
        end

        context 'with binding' do
          let(:binding) { Object.__binding__ }
          let(:string) { 'constants' }
          it { is_expected.to eq(Object.constants) }
        end
      end

      context 'given dangerous string' do
        let(:string) { "FileUtils.rm('#{Tempfile.new.path}')" }

        it 'prevent to evaluate the string' do
          expect { subject }.to raise_error(SecurityError)
        end
      end
    end
  end
end

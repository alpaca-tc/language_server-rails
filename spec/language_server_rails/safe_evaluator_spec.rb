# frozen_string_literal: true

RSpec.describe LanguageServerRails::SafeEvaluator do
  describe 'ClassMethods' do
    describe 'no_side_effect?' do
      subject { described_class.no_side_effect?(string, current_binding) }
      let(:current_binding) { TOPLEVEL_BINDING }

      context 'given self' do
        let(:string) { 'self' }
        it { is_expected.to be true }
      end

      context 'given constant' do
        let(:string) { 'Object' }
        it { is_expected.to be true }
      end

      context 'given variable' do
        let(:current_binding) do
          variable = 1
          binding
        end

        let(:string) { 'variable' }
        it { is_expected.to be true }
      end

      context 'given method' do
        let(:string) { 'puts' }
        it { is_expected.to be false }
      end

      context 'given 1' do
        let(:string) { '1' }
        it { is_expected.to be false }
      end

      context 'given SyntaxError string' do
        let(:string) { '==' } # SyntaxErrorになる
        it { is_expected.to be false }
      end
    end

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

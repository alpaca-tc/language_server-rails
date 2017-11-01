RSpec.describe LanguageServerRails::Path do
  describe '.executable?' do
    context 'given unknown command' do
      subject { described_class.executable?('unknown_command') }
      it { is_expected.to be false }
    end

    context 'given executable command' do
      subject { described_class.executable?('ruby') }
      it { is_expected.to be true }
    end
  end
end

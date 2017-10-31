# frozen_string_literal: true

RSpec.describe LanguageServerRails::Configuration do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(project_root) }
    let(:project_root) { __dir__ }

    describe '#pidfile_path' do
      subject { instance.pidfile_path }
      it { is_expected.to be_a(Pathname) }
      it { expect(subject.to_s).to end_with('.pid') }
    end

    describe '#socket_path' do
      subject { instance.socket_path }
      it { is_expected.to be_a(Pathname) }
      it { expect(subject.to_s).to end_with('.sock') }
    end

    describe '#socket_name' do
      subject { instance.socket_name }
      it { is_expected.to end_with('.sock') }
    end
  end
end

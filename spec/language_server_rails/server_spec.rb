# frozen_string_literal: true

require 'fileutils'

RSpec.describe LanguageServerRails::Server do
  let(:instance) do
    described_class.new(
      socket_path: configuration.socket_path,
      pidfile_path: configuration.pidfile_path
    )
  end

  let(:configuration) { LanguageServerRails::Configuration.new(project_root) }
  let(:project_root) { __dir__ }

  describe 'InstanceMethods' do
    describe '#serve' do
      subject do
        -> { instance.__send__(:serve, server) }
      end

      def send_json(data)
        data = JSON.dump(data)
        client.puts(data.bytesize)
        client.write(data)
      end

      let(:unix_socket) { UNIXSocket.pair }
      let(:server) { unix_socket[0] }
      let(:client) { unix_socket[1] }

      after do
        server.close
        client.close
      end

      it 'executes eval command' do
        send_json(id: 1, command: 'eval', script: 'Object.constants')

        subject.call

        response = JSON.parse(client.read(client.gets.to_i))

        expect(response['id']).to eq(1)
        expect(response['status']).to eq('success')
        expect(response['data']).to eq(Object.constants.map(&:to_s))
      end
    end

    describe '#shutdown' do
      subject do
        -> { instance.__send__(:shutdown) }
      end

      before do
        FileUtils.touch(configuration.socket_path)
        FileUtils.touch(configuration.pidfile_path)
      end

      it 'deletes pid file and socket file' do
        is_expected.to change {
          [configuration.socket_path.exist?, configuration.pidfile_path.exist?]
        }.from([true, true]).to([false, false])
      end
    end

    describe '#write_pid_file' do
      subject do
        -> { instance.__send__(:write_pid_file) }
      end

      before do
        FileUtils.rm(configuration.pidfile_path) if configuration.pidfile_path.exist?
      end

      it 'write pid file' do
        is_expected.to change(configuration.pidfile_path, :exist?).from(false).to(true)
        expect(File.read(configuration.pidfile_path)).to eq("#{Process.pid}\n")
      end
    end
  end
end

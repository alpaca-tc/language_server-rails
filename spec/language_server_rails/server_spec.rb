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
  let(:project_root) { gemspec_sample_root }

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

    fdescribe '#process' do
      subject do
        instance.__send__(:process, id, command, script, socket)
        read_socket
      end

      let(:id) { 1 }
      let(:socket) { StringIO.new }

      def read_socket
        current_position = socket.pos
        socket.rewind
        length = socket.gets.to_i
        JSON.parse(socket.read(length), symbolize_names: true) if length.positive?
      ensure
        socket.pos = current_position
      end

      describe 'given eval command' do
        let(:command) { 'eval' }
        let(:script) { 'Object.constants' }

        it 'evaluates script' do
          is_expected.to eq(
            id: 1,
            status: 'success',
            data: Object.constants.map(&:to_s)
          )
        end
      end

      describe 'given find_definition command' do
        let(:command) { 'find_definition' }
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
          let(:script) { 'GemspecSample::ForDefinitionFinder#please_find_me' }

          it 'finds definition' do
            is_expected.to eq(
              id: 1,
              status: 'success',
              data: GemspecSample::ForDefinitionFinder.instance_method(:please_find_me).source_location
            )
          end
        end

        context 'given const name' do
          let(:script) { 'GemspecSample::ForDefinitionFinder' }
          let(:instance_methods) { GemspecSample::ForDefinitionFinder.instance_methods(false) }
          let(:const_file) { GemspecSample::ForDefinitionFinder.instance_method(instance_methods.first).source_location[0] }

          it 'finds definition' do
            lines = File.read(const_file).split("\n")
            line = lines.find { |line| line =~ /class ForDefinitionFinder/ }
            line = lines.index(line)

            is_expected.to eq(
              id: 1,
              status: 'success',
              data: [const_file, line]
            )
          end
        end
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

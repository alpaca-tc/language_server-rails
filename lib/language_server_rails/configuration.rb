# frozen_string_literal: true

require 'tmpdir'
require 'digest/md5'

module LanguageServerRails
  class Configuration
    def self.temporary_directly
      @temporary_directly ||= Pathname.new(Dir.tmpdir)
    end

    attr_reader :project_root
    attr_writer :temp_path

    def initialize(project_root)
      @project_root = project_root
    end

    def pidfile_path
      temporary_directly.join("#{application_id}.pid")
    end

    def socket_path
      temporary_directly.join("#{application_id}.sock")
    end

    def socket_name
      socket_path.to_s
    end

    private

    def temporary_directly
      self.class.temporary_directly
    end

    def application_id
      Digest::MD5.hexdigest("#{RUBY_VERSION}#{project_root}")
    end
  end
end

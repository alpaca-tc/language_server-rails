# frozen_string_literal: true

require 'pathname'

Module.new do
  def rails_root
    Pathname.new(File.expand_path('../../dummy', __FILE__))
  end

  def gemspec_sample_root
    Pathname.new(File.expand_path('../../gem_project_dummy', __FILE__))
  end

  RSpec.configure do |config|
    config.include(self)
  end
end

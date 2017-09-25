require 'spec_helper'

RSpec.describe LanguageServerJson do
  it 'has a version number' do
    expect(LanguageServerJson::VERSION).not_to be nil
  end
end

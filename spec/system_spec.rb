require "spec_helper"
require 'pathname'

describe RubygemDigger do

  subject {RubygemDigger::Digger.new}

  describe 'system' do
    its(:dig!) {is_expected.to be_successful}
  end

end




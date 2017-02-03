require "spec_helper"
require 'pathname'

describe RubygemDigger::Cacheable do
  class MyCacheable
    include RubygemDigger::Cacheable
  end

  before {MyCacheable.invalidate}

  describe 'collection' do
    subject {MyCacheable.all}
    its(:size) {is_expected.to eq 0}
  end

  describe 'an object' do
    subject {Mcacheable.new}
  end

end



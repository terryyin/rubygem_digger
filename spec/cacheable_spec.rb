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

    context 'when the ojbect is cached' do
      before {subject.cache}
      it {is_expected.to eq MayCacheable}
    end
  end

end



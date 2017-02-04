$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rubygem_digger"
RubygemDigger::Cacheable.base_path = File.expand_path("../../data", __FILE__)

require 'rspec/its'

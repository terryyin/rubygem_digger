require 'spec_helper'
require 'pathname'

describe RubygemDigger::GithubDigger do
  subject { RubygemDigger::GithubDigger.load 'https://github.com/terryyin/lizard' }
  # its(:stars_count) { is_expected.to be > 270 }
  # its(:issues_count) { is_expected.to be <= 30 }

  context 'when not found' do
    let(:repos) { double }
    before { allow(Github).to receive(:repos) { repos } }
    before { allow(repos).to receive(:get).and_raise Github::Error::NotFound.new({}) }
    xit { is_expected.to be_nil }
  end

  describe 'for none github url' do
    subject { RubygemDigger::GithubDigger.load 'https://githb.com/terryyin/lizard' }
    xit { is_expected.to be_nil }
  end

  describe 'xxx' do
    subject { RubygemDigger::GithubDigger.load 'http://github.com/brighterplanet/brighter_planet_layout' }
    xit { is_expected.to be_nil }
  end

  describe '#issues_updated_after' do
    subject { RubygemDigger::GithubDigger.issues_updated_after 'https://github.com/terryyin/lizard', Time.utc(2016, 8, 1) }
    xit { is_expected.to be 15 }
  end
end

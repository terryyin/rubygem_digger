require "spec_helper"
require 'pathname'

describe RubygemDigger do
  let(:data_path) {Pathname.new(__FILE__).join('../data/')}
  describe RubygemDigger::GemHistory do
    subject {RubygemDigger::GemHistory.new data_path, 'bash-session', ['0.0.1', '0.0.2', '0.0.3']}
    its(:last_change_at) {is_expected.to eq Time.utc(2017, 1, 13).utc}
    its(:months_with_versions) {is_expected.to eq 3}

    describe '#complicated_enough' do
      it{expect(subject.complicated_enough(2000)).to be_falsey}
    end

    describe '#last_package' do
      its(:last_package) {is_expected.to be_a RubygemDigger::CachedPackage}
      it {expect(subject.last_package.nloc).to eq 164}
    end
  end
end



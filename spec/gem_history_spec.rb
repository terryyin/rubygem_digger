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

    describe "zurb-foundation" do
      subject {RubygemDigger::GemHistory.new data_path, 'zurb-foundation', ["0.0.5", "1.0.0", "2.0.0", "2.0.1", "2.0.2", "2.0.3.1", "2.0.3.2", "2.0.3.3", "2.1.0", "2.1.2", "2.1.3", "2.1.3.1", "2.1.4", "2.1.4.1", "2.1.4.2", "2.1.4.3", "2.1.5.0", "2.1.5.1", "2.2.0.1", "2.2.0.2", "2.2.1.0", "2.2.1.1", "2.2.1.2", "3.0.3", "3.0.4", "3.0.5", "3.0.6", "3.0.7", "3.0.8", "3.0.9", "3.1.0", "3.1.1", "3.2.0", "3.2.2", "3.2.3", "3.2.4", "3.2.5", "4.0.0", "4.0.1", "4.0.2", "4.0.3", "4.0.4", "4.0.5", "4.0.7", "4.0.8", "4.0.9", "4.1.1", "4.1.2", "4.1.5", "4.1.6", "4.2.0", "4.2.1", "4.2.2", "4.2.3", "4.3.0", "4.3.1", "4.3.2"]}
      it {expect(subject.last_package.version).to eq "4.3.2"}
      it {expect(subject.major_versions.count).to eq 21}
      it {expect(subject.last_change_at).to be > Time.parse("2013-09-01")}
      it {expect(subject.keep_months(10).major_versions.count).to eq 10}
      it {expect(subject.keep_months(12).last_package.version).to eq "4.3.2"}
    end
  end
end



require 'spec_helper'
require 'pathname'

describe RubygemDigger do
  let(:data_path) { Pathname.new(__FILE__).join('../data/') }
  describe 'package' do
    subject { RubygemDigger::PackageWrapper.new data_path, 'bash-session', '0.0.1' }
    its(:nloc) { is_expected.to eq 164 }
    its(:style_) { is_expected.to be_within(1).of(146) }
  end
end

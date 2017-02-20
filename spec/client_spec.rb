require 'spec_helper'
require 'client'

describe Client do
  subject { Client::Client.new('http://localhost:3000') }
  describe '#apply_job' do
    xit { subject.apply_job }
  end

  describe '#submit_job' do
    xit { subject.submit_job(1) }
  end

  describe '#do_a_job' do
    it { subject.do_job }
  end
end

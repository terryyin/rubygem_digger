require "spec_helper"

describe Client do
  it "has a version number" do
    expect(Client::VERSION).not_to be nil
  end

  subject {Client::Client.new("http://localhost:3000")}
  describe "#apply_job" do
    xit {subject.apply_job}
  end

  describe "#submit_job" do
    xit {subject.submit_job(1)}
  end

  describe "#do_a_job" do
    it {subject.do_job}
  end

end

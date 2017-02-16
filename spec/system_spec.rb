require "spec_helper"
require 'pathname'

describe RubygemDigger do

  let(:version) {"1"}
  subject {
    begin
      RubygemDigger::Digger.new.dig(version) do |a, b, c|
        #p a, b, c
      end
    rescue RubygemDigger::Error::StopAndWait
      p "...........Stopped and Waiting"
    end
  }

  %w{2}.each do |v|
    context "build" do
      it {
      RubygemDigger::Digger.new.dig(v) do |a, b, c|
        #p a, b, c
      end
      }
    end
  end

  describe 'system' do
    #its(:dig!) {is_expected.to be_successful}
    xit {
      context = subject
      expect(context[:maintain_stopped].get("cancan")).not_to be_nil
      p context[:maintain_stopped_with_issues].list.collect(&:name)
      context[:maintain_stopped_with_issues].list.each do |h|
        github = h.github
        print "| "
        print h.name
        print " | "
        print github.issues_updated_after(h.last.date)
        print " | "
        print (((Time.now - h.last.date) * 10 / 60/ 60/24/365).to_i)/10.0
        print " | "
        print github.url
        print " | |\n"
      end
    }

    it {
      RubygemDigger::Digger.new.past_specs. each do |v, t|
        print "| "
        print t[:version]
        print "| "
        print t[:description]
        print "| "
        print t[:min_months]
        print "| "
        print t[:min_nloc]
        print "| "
        print t[:min_months_good]
        print "| "
        print t[:history_months]
        print "| "
        print t[:ignored_months_for_good]
        print "|\n"
      end
    }
  end

end




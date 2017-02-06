require "client/version"
require 'net/http'
require 'rest_client'
require 'json'
require '../rubygem_digger'


module Client
  class Client
    def initialize(url)
      @base_url = URI(url)
    end

    def apply_job
      res = Net::HTTP.post_form(URI.join(@base_url, 'working_items/apply_job'), {})
      puts res.body
      JSON.parse(res.body)
    end

    def submit_job(id)
      res = RestClient.post(URI.join(@base_url, 'working_items/submit_job').to_s, id: id, working_item: {upload: File.open('/Users/terry/git/rubygem_digger/spec/data/gems/sequel-4.17.0.gem', 'rb')})
      puts res.body
    end

    def do_job
      jobs = apply_job
      jobs.each do |job|
        obj = RubygemDigger::Cacheable.create_or_load_by_type(job['work_type'], job['content'], job['version'])
        submit_job(job["id"], obj) if obj
      end
    end

  end
end

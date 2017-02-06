require 'net/http'
require 'rest_client'
require 'json'
require 'open-uri'


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

    def submit_job(id, filename)
      p filename
      res = RestClient.post(URI.join(@base_url, 'working_items/submit_job').to_s, id: id, working_item: {upload: File.open(filename, 'rb')})
      puts res.body
    end

    def do_job
      saved_path = Pathname.new(File.expand_path("../../../client_cache/", __FILE__))
      RubygemDigger::CachedPackage.gems_path = Pathname.new(File.expand_path("../../../client_cache/", __FILE__))
      jobs = apply_job
      jobs.each do |job|
        gem = RubygemDigger::CachedPackage.default_gems_path.join("gems/#{job['content']}.gem")
        p gem
        unless File.exists?(gem)
          open(gem, "wb") do |file|
            file << open(URI.join(@base_url, "download/#{job['content']}.gem")).read
          end
        end

        obj = RubygemDigger::Cacheable.create_or_load_by_type(job['work_type'], job['content'], job['version'])
        filename = obj.class.cache_filename_from_content(job['content'])
        submit_job(job["id"], filename) if obj
      end
      RubygemDigger::CachedPackage.gems_path = saved_path
    end

    def run
      while true
        do_job
        sleep 0.01
      end
    end
  end
end

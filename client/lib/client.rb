require "client/version"
require 'net/http'


module Client
  class Client
    def initialize(url)
      @base_url = URI(url)
    end

    def apply_job
      res = Net::HTTP.post_form(URI.join(@base_url, 'working_items/apply_job'), {})
      puts res.body
    end

    def apply_job(id)
      res = Net::HTTP.post_form(URI.join(@base_url, 'working_items/apply_job'), {})
      puts res.body
    end

  end
end

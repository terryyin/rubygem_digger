require 'net/http'
require 'rest_client'
require 'json'
require 'open-uri'

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
    res = RestClient.post(URI.join(@base_url, 'working_items/submit_job').to_s, id: id, working_item: { upload: File.open(filename, 'rb') })
    puts res.body
  end

  def do_job
    RubygemDigger::CachedPackage.gems_path = Pathname.new(File.expand_path('../../../client_cache/', __FILE__))
    jobs = apply_job
    jobs.each do |job|
      gem = RubygemDigger::CachedPackage.new.gems_path.join("gems/#{job['content']}.gem")
      p gem
      unless File.exist?(gem)
        p 'Downloading...'
        open(gem, 'wb') do |file|
          file << open(URI.join(@base_url, "download/#{job['content']}.gem")).read
        end
      end

      p 'Load or create...'
      obj = RubygemDigger::Cacheable.create_or_load_by_type(job['work_type'], job['content'], job['version'])
      filename = obj.class.cache_filename_from_content(job['content'])
      p "data file: #{filename}"
      p "data: #{obj.stats}"
      submit_job(job['id'], filename) if obj
    end
  end

  # Client::Client.new("http://192.168.1.247:3000").run
  def run
    loop do
      begin
        do_job
        sleep 0.1
      rescue => e
        p '!!!!!!!!!!!!!!!!!1Erorr Happend!!!!!!!!!!!!!!!!!!!!!!1'
        p e.message
        print e.backtrace
        p e.message
        p '---------------------------------------'
        sleep 1
        raise
      end
    end
  end
end

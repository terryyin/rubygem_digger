require "rubygem_digger/cacheable"
require 'github_api'

module RubygemDigger
  class GithubDigger
    def self.load(url)
      if url =~ %r{github\.com/(\w+)/(\w+)}
        repo = Github.repos.get($~[1], $~[2])
        if repo.status == 200
          self.new repo, $~[1], $~[2]
        else
          nil
        end
      end
    rescue Github::Error::NotFound
      nil
    end

    def initialize(repo, user, reponame)
      @repo = repo
      @user = user
      @reponame = reponame
    end

    def stars_count
      @repo.stargazers_count
    end

    def issues_count
      @repo.open_issues
    end

    def issues_updated_after(time)
      issues.select do |i|
        Time.parse(i.updated_at) > time
      end.count
    end

    def issues
      @issues ||= _issues
    end

    private
    def _issues
      i = Github::Client::Issues.new.all(user: @user, repo: @reponame)
      return [] unless i.status == 200
      i
    rescue Github::Error::NotFound
      []
    end

  end

  class CachedGithubDigger
    include Cacheable
    self.version = 0

    def self.instance_name(context)
      "#{context[:url]&.gsub(/[\/\\\?\#\:]+/,'-')}"
    end

    def self.plan_job(context)
      [self.class.name, context[:url], self.version]
    end

    def create(context)
      if context[:url] =~ %r{github\.com/(\w+)/(\w+)}
        @github = GithubDigger.new(nil, $~[1], $~[2])
      end
    end

    def issues_updated_after(time)
      p @github&.issues_updated_after(time)
      @github&.issues_updated_after(time)
    end
  end
end

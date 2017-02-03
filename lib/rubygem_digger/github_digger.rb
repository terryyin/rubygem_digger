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

    def self.issues_updated_after(url, time)
      if url =~ %r{github\.com/(\w+)/(\w+)}
        all = issues($~[1], $~[2])
        return 0 unless all.status == 200
        all.select do |i|
          Time.parse(i.updated_at) > time
        end.count
      end
    rescue Github::Error::NotFound
      nil
    end

    def self.issues(user, reponame)
      issues = Github::Client::Issues.new
      issues.all user: user, repo: reponame
    end

  end
end

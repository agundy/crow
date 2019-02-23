require 'octokit'

class GithubRepositories
  def initialize
    if github_access_token = ENV['GITHUB_ACCESS_TOKEN']
      @client = Octokit::Client.new(:access_token => github_access_token, per_page: 5)
      # auto paginate so we don't have to worry about looping through api repo
      # response
      @client.auto_paginate = true
    else
      STDERR.puts "Needed GITHUB_ACCESS_TOKEN environment variable not found"
      exit 1
    end
  end

  def list
    if @client
      names = repos.map do |repo|
        repo[:full_name]
      end
    else
      ['No Repos']
    end
  end

  def git_urls
    nestable_repos = repos.map do |repo|
      {
        name: repo.name,
        username: repo.owner.login,
        ssh_url: repo.ssh_url
      }
    end
  end

  private

  def repos
    @repos ||= @client.repos({}, query: repo_owner_query)
  end

  # Github API query that limits response to only repo's you own
  def repo_owner_query
    {type: 'owner', sort: 'asc'}
  end
end

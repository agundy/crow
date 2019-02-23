require 'set'
require 'git'

class Nest
  # Nest manages keeping your remote files in a local location
 
  def initialize(options={})
    @mirror = options[:mirror] ? true :false
  end

  def store
    @github = GithubRepositories.new
    store_repos(:github, @github.git_urls)
  end

  def update
    puts "Updating repos in: #{File.join(Dir.pwd, 'github')}"
    repos = local_repos(:github)
    if repos.length > 0
      repos.each do |repo_path|
        puts "updating #{repo_path}"
        update_repo(repo_path)
      end
    else
      puts "  no repos to update!"
    end
  end

  def stored
    puts "looking in: #{File.join(Dir.pwd, 'github')}"
    local_repos(:github).each {|r| puts r }
  end

  private

  # takes a source name and a list of repositories with names and paths,
  # and tries to clone or update that repo
  def store_repos(source, repos)
    ensure_source_dir_exists! source

    puts "Storing Repositories from: #{source}"
    local_repos = local_repos(source)

    repos.each do |repo|
      repo_dir_name = "#{repo[:name]}.git"
      relative_repo_directory = File.join(source.to_s, repo[:username].to_s, repo_dir_name)
      if local_repos.include? relative_repo_directory
        puts "#{repo[:name]} existing repo, updating."
        update_repo(relative_repo_directory)
      else
        puts "#{repo[:name]} new repo, cloning. to #{relative_repo_directory}"
        clone_repo(repo[:ssh_url], relative_repo_directory)

      end
    end
  end

  def ensure_source_dir_exists!(source_dir)
    if !Dir.exists? source_dir.to_s
      Dir.mkdir source_dir.to_s
    end
  end

  def local_repos(source)
    local_repos = Set.new()
    directories = Dir.glob(File.join(source.to_s, "*", "**"))
    directories.each do |dir|
      local_repos.add(dir)
    end

    local_repos
  end

  def clone_repo(url, repo_path)
    Git.clone(url, repo_path, mirror: true)
  end

  def update_repo(repo_path)
    git = Git.bare(repo_path)
    git.fetch '--all'
  end
end

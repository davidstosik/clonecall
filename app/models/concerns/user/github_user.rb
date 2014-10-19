class User < ActiveRecord::Base
  module GithubUser
    extend ActiveSupport::Concern

    def octokit
      @octokit ||= Octokit::Client.new access_token: token
    end

    def github_account
      @github_account ||= octokit.user
    end

    def github_name
      github_account.name || github_account.login
    end

    def organizations
      @organizations ||= Hash[octokit.organizations.map do |org|
        [org.login, org]
      end]
    end

    def repository full_name
      @uniq_repos ||= {}

      all_cached_repos =
        (@org_repos||{}).values.push(@user_repos||{}).inject({}) do |mem, h|
          mem.merge! h
        end

      @uniq_repos[full_name] ||= all_cached_repos[full_name]
      @uniq_repos[full_name] ||= Repository.new full_name, self
    end

    def user_repositories
      @user_repos ||= Hash[octokit.repositories.map do |data|
        [data.full_name, Repository.new(data.full_name, self, data)]
      end]
    end

    def org_repositories
      @org_repos ||= Hash[organizations.map do |login, org|
        [
          login,
          Hash[octokit.organization_repositories(org.id, type: :member).map do |data|
            [data.full_name, Repository.new(data.full_name, self, data)]
          end]
        ]
      end]
    end

    def repositories
      @all_repos ||= org_repositories.values.push(user_repositories).inject({}) do |mem, h|
        mem.merge! h
      end
    end

  end
end

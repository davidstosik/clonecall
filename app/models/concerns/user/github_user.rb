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

    def repositories
      @repositories ||= Hash[octokit.repositories.map do |data|
        [data.full_name, Repository.new(data, self)]
      end]
    end

    def repository full_name
      @uniq_repos ||= {}

      @uniq_repos[full_name] ||=
      (@organization_repositories || {}).merge(nil: @repositories).values.inject {|h,mem| mem.merge! h }[full_name] ||
      Repository.find(full_name, self)
    end

    def organizations
      @organizations ||= octokit.organizations
    end

    def organization_repositories
      @organization_repositories ||= Hash[organizations.map do |organization|
        [
          organization,
          Hash[octokit.organization_repositories(organization.id, type: :member).map do |data|
            [data.full_name, Repository.new(data, self)]
          end]
        ]
      end]
    end

    def all_repositories
      @all_repositories = organization_repositories.merge(nil: repositories).values.inject {|h,mem| mem.merge! h }
    end

  end
end

class User
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
      @repositories ||= octokit.repositories
    end

    def organizations
      @organizations ||= octokit.organizations
    end

    def organization_repositories
      @organization_repositories ||= Hash[organizations.map do |organization|
        [organization, octokit.organization_repositories(organization.id, type: :member)]
      end]
    end

  end
end

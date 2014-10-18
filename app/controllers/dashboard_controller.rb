class DashboardController < ApplicationController
  def index
    client = Octokit::Client.new access_token: current_user.token
    @github_user = client.user
    @repos = {}
    @repos[:user] = client.repos
    @repos[:orgs] = Hash[client.orgs.map do |org|
      org = client.org(org.id)
      [org, client.organization_repositories(org.id, type: :member)]
    end]
    Rails.logger.debug @repos
  end
end

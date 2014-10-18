class DashboardController < ApplicationController
  def index
    client = Octokit::Client.new access_token: current_user.token
    @repos = client.repos
  end
end

class DashboardController < ApplicationController
  def index
    @repos = {}
    @repos[:user] = current_user.repositories
    @repos[:orgs] = current_user.organization_repositories
  end
end

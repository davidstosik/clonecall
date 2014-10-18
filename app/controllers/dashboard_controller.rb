class DashboardController < ApplicationController
  def index
    @repos = current_user.all_repositories
  end
end

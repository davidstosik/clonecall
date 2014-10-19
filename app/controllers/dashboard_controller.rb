class DashboardController < ApplicationController
  def index
    @repos = current_user.repositories
  end
end

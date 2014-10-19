class DashboardController < ApplicationController
  def index
    @repos = current_user.repositories
    @clonecalls = []
  end
end

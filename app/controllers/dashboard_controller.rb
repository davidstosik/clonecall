class DashboardController < ApplicationController
  before_filter :authorize

  def index
    @repos = current_user.repositories
    @clonecalls = []
  end
end

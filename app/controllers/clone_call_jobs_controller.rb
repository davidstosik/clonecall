class CloneCallJobsController < ApplicationController
  before_filter :authorize

  def new
    @clone_call_job = CloneCallJob.new user: current_user
    @repo_options = current_user.repositories.map do |name, repo|
      [name, name]
    end
  end
  
end

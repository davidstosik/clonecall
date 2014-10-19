class CloneCallJobsController < ApplicationController
  before_filter :authorize

  def index
    @jobs = current_user.clone_call_jobs.reverse
    @running_count = current_user.clone_call_jobs.running.count
  end

  def new
    @clone_call_job = scope.new start_at: 45.hours.ago.utc, end_at: Time.now.utc, branch: 'master'
    @repo_options = current_user.repositories.keys
  end

  def create
    @clone_call_job = scope.new params.require(:clone_call_job)
      .permit %w(src_repo branch dst_repo start_at end_at)

    if @clone_call_job.save
      #flash! :success
      redirect_to clone_call_jobs_path
    else
      #flash! :error
      render 'new'
    end

  end

  private

  def scope
    current_user.clone_call_jobs
  end
  
end

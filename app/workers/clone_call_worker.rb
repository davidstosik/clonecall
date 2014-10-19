class CloneCallWorker
  include Sidekiq::Worker

  def perform(id)
    job = CloneCallJob.find id

    job.source_repository.clonecall job.dest_repository, job.branch, job.start_at, job.end_at
  end

end

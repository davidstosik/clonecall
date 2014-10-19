class CloneCallWorker
  include Sidekiq::Worker

  def perform(id)
    job = CloneCallJob.find id

    job.update(
      total_commits: job.source_repository.commits.count,
      status: 'running',
    )

    job.source_repository.clonecall job.dest_repository, job.branch, job.start_at, job.end_at

    job.update status: 'done'
  end

end

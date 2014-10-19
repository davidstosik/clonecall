class CloneCallJob < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :src_repo, :dst_repo, :start_at, :end_at, :user
  validate :dates_are_valid

  after_create :setup_worker

  default_scope -> { order created_at: :asc }
  scope :running, -> { where status: 'running' }
  scope :done, -> { where status: 'done' }

  def setup_worker
    CloneCallWorker.perform_async id
  end

  def source_repository
    user.repository src_repo
  end

  def dest_repository
    user.repository dst_repo
  end

  def completion
    user.git_object_clones.where(
      git_type: 'commit',
      src_repo: src_repo,
      dst_repo: dst_repo,
    ).count * 100 / total_commits
  end

  private

  def dates_are_valid
    if end_at < start_at
     errors.add(:start_at, "cannot be after the end date")
    end

    if end_at > Time.now
     errors.add(:end_at, "cannot be after now")
    end
  end

end

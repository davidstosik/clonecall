class CloneCallJob < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :src_repo, :dst_repo, :start_at, :end_at, :user
  validate :dates_are_valid

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

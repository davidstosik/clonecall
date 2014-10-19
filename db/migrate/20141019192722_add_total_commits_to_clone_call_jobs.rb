class AddTotalCommitsToCloneCallJobs < ActiveRecord::Migration
  def change
    add_column :clone_call_jobs, :total_commits, :integer
  end
end

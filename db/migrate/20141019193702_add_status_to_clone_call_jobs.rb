class AddStatusToCloneCallJobs < ActiveRecord::Migration
  def change
    add_column :clone_call_jobs, :status, :string
  end
end

class CreateCloneCallJobs < ActiveRecord::Migration
  def change
    create_table :clone_call_jobs do |t|
      t.integer :user_id
      t.string :src_repo
      t.string :dst_repo
      t.string :branch
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end

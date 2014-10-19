class CreateGitObjectClones < ActiveRecord::Migration
  def change
    create_table :git_object_clones do |t|
      t.integer :user_id
      t.string :git_type
      t.string :src_repo
      t.string :src_sha
      t.string :dst_repo
      t.string :dst_sha

      t.timestamps
    end
  end
end

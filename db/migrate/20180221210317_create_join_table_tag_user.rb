class CreateJoinTableTagUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :tags, :users do |t|
      t.index [:tag_id, :user_id], unique: true
      t.index [:user_id, :tag_id], unique: true
    end
  end
end

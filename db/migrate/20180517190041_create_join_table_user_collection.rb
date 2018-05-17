class CreateJoinTableUserCollection < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :collections do |t|
      t.index [:user_id, :collection_id]
      t.index [:collection_id, :user_id]
    end
  end
end

class CreateJoinTableUserNote < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :notes do |t|
      t.index [:user_id, :note_id]
      t.index [:note_id, :user_id]
    end
  end
end

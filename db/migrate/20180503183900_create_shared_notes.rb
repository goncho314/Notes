class CreateSharedNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :sharedNote do |t| 
      t.references :user
      t.references :sharedUser
      t.references :note
  
      t.timestamps 
    end
      
    add_index :sharedNote, :user
    add_index :sharedNote, :sharedUser
    add_index :sharedNote, :note
  end
end

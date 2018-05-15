class CreateJoinTableCollectionNote < ActiveRecord::Migration[5.1]
  def change
    create_join_table :collections, :notes do |t|
      t.index [:collection_id, :note_id]
      t.index [:note_id, :collection_id]
    end
  end
end

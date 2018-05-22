class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.references :owner
      t.string :text

      t.timestamps
    end
  end
end
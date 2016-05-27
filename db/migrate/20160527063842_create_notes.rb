class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title, null: false, default: ''
      t.text :body, null: false, default: ''
      t.references :user, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateThemas < ActiveRecord::Migration
  def change
    create_table :themas do |t|
      t.string :name
      t.integer :part
      t.references :level
      t.timestamps
    end
  end
end

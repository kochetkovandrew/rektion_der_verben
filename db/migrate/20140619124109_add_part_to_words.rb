class AddPartToWords < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.integer :part
    end
    remove_column :themas, :part
  end
end

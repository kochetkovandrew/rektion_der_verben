class AddPartToVerbsRektions < ActiveRecord::Migration
  def change
    change_table :verbs_rektions do |t|
      t.integer :part
    end
  end
end

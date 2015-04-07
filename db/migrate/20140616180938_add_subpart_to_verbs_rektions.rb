class AddSubpartToVerbsRektions < ActiveRecord::Migration
  def change
    change_table :verbs_rektions do |t|
      t.integer :subpart
    end
  end
end

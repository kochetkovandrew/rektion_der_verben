class AddClarificationToVerbsRektion < ActiveRecord::Migration
  def change
    change_table :verbs_rektions do |t|
      t.string :clarification
    end
  end
end

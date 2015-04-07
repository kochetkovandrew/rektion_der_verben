class CreateVerbsRektions < ActiveRecord::Migration
  def change
    create_table :verbs_rektions do |t|
      t.string :verb
      t.string :preposition
      t.string :case
      t.string :translation

      t.timestamps
    end
  end
end

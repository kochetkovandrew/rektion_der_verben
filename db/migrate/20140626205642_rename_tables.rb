class RenameTables < ActiveRecord::Migration
  def up
    rename_table :themas, :topics
    rename_table :verbs_rektions, :verbs
    rename_column :words, :thema_id, :topic_id
  end

  def down
    rename_table :topics, :themas
    rename_table :verbs, :verbs_rektions
    rename_column :words, :topic_id, :thema_id
  end
end

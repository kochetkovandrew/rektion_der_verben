class AddKindToWords < ActiveRecord::Migration
  def change
    change_table :words do |t|
      t.string :speech_part
      t.string :article
    end
  end
end

class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name

      t.timestamps
    end
    ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'].each do |level_name|
        Level.create :name => level_name
    end
  end
end

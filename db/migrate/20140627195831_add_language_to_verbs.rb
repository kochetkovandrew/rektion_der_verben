class AddLanguageToVerbs < ActiveRecord::Migration
  def change
    change_table :verbs do |t|
      t.string :language
    end
    Verb.all.each do |verb|
      verb.language = 'de'
      verb.save
    end
  end
end

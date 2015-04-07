class Word < ActiveRecord::Base
  attr_accessible :translation, :word, :topic_id, :part, :speech_part, :article
  belongs_to :topic
  
  def topic_part
    topic.full_name + ' ' + part.to_s
  end
end

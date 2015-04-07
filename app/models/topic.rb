class Topic < ActiveRecord::Base
  attr_accessible :name, :level_id
  belongs_to :level
end

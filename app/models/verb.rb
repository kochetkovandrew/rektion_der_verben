class Verb < ActiveRecord::Base
  attr_accessible :case, :preposition, :translation, :verb, :part, :clarification, :subpart
  validates :case, :presence => true, :if => lambda { |v| !Settings[v.language].nil? && Settings[v.language]['use_case'] }
  validates :translation, :presence => true
  validates :verb, :presence => true
  validates :part, :presence => true
  validates :part, :numericality => { :only_integer => true }
end

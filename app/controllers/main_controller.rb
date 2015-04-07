class MainController < ApplicationController

  def index
    @verbs_parts = Verb.where(:language => @language).all.collect{|v| [ v.part, v.part]}.uniq.sort
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
end

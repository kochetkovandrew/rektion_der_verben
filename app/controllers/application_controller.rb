class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_language
  before_filter :set_locale
 
  def set_language
    @language = cookies[:language] || I18n.default_locale
  end
 
  def set_locale
    I18n.locale = params[:locale] || cookies[:language] || I18n.default_locale
  end

end

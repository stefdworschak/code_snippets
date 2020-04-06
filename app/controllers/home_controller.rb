require 'external_user_info_adapter'
class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    redirect_to '/'
  end
end

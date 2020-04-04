require 'user_rep_adapter'
class HomeController < ApplicationController
  def index
    settings = {
      "github_api_user" => Rails.application.credentials.github_api_user,
      "github_api_token" => Rails.application.credentials.github_api_token,
      "stackoverflow_key" => Rails.application.credentials.stackoverflow_key
    }
      user_rep = UserRepAdapter.instance()
      user_rep.set_settings(settings)
      @reputation = user_rep.get_user_reputation(1)
  end
end

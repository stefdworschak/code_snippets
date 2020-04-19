require 'external_user_info_adapter'
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, :only => [:index, :destroy]
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def signedinuserprofile 
    profile = Profile.find_by_user_id(current_user.id)
    if profile.nil?
      redirect_to "/profiles/new"
    else
      @profile = Profile.find_by_user_id(current_user.id)
      redirect_to "/profiles/#{@profile.id}"
    end
  end

  def ensure_admin
    unless current_user && current_user.admin?
      redirect_to "/"
    end
  end


  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.joins("INNER JOIN users ON users.id = profiles.user_id")
                       .select("profiles.*, users.email")
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @stackoverflow_url = "#"
    settings = {
        "github_api_user" => ENV['GITHUB_API_USER'],
        "github_api_token" => ENV['GITHUB_API_TOKEN'],
        "stackoverflow_key" => ENV['STACKOVERFLOW_KEY']
    }
    external_info = ExternalUserInfoAdapter.instance()
    external_info.set_settings(settings)
    profile = Profile.find(params[:id])
    if profile.avatar_url.to_s.empty?
      @avatar = external_info.get_user_avatar_url(profile.user_id)
      if !@avatar.nil?
        profile.update(avatar_url: @avatar)
      end
    else
      @avatar = profile.avatar_url
    end
    @stackoverflow_link = external_info.get_stackoverflow_link(profile.user_id)
    @snippets = Snippet.where(:user_id => profile.user_id)
    @snippet = Snippet.new
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    @profile.user_id = current_user.id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @profile } 
    end
  end

  # GET /profiles/1/edit
  def edit
    user_id = params[:id]
    if current_user.id != user_id.to_i && !current_user.admin?
      redirect_to "/"
    end
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to '/', notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to '/', notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:user_id, :display_name, :github_name, :stackoverflow_name, :stackoverflow_userid, :avatar_url, :avatar_url_source)
    end
end

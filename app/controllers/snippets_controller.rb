require 'uri'
require 'date'
require 'external_user_info_adapter'
class SnippetsController < ApplicationController
  protect_from_forgery unless: -> { request.original_url.include?('snippets/') }
  before_action :authenticate_user!
  before_action :set_snippet, only: [:show, :edit, :update, :destroy]

  def ensure_admin
    unless current_user && current_user.admin?
      render :text => "Access Error Message", :status => :unauthorized
    end
  end

  # GET /snippets
  # GET /snippets.json
  def index
    snippets = Snippet.joins("INNER JOIN users ON snippets.user_id = users.id")
                      .joins("INNER JOIN profiles ON users.id = profiles.user_id")
                      .select("snippets.id, snippets.user_id, snippets.code, " \
                              "snippets.title, snippets.created_at, snippets.updated_at, " \
                              "users.email, profiles.display_name, profiles.github_name, " \
                              "profiles.stackoverflow_name")
                      .order('snippets.created_at DESC')
    if not params.has_key?(:search)
      @snippets = snippets.all
    elsif params[:search].to_s.empty?
      @snippets = []
    else 
      search = params[:search]
      search_type = search[0]
      keyword = URI.decode(search[1,search.length])
      if search_type == ':'
        @snippets = snippets.where("LOWER(title) LIKE '%#{keyword}%'" \
                                   " OR LOWER(code) LIKE '%#{keyword}%'")
                            .order('snippets.created_at DESC').all
      elsif search_type == '@'
        @snippets = snippets.where("LOWER(display_name) LIKE '%#{keyword}%'" \
                                   " OR LOWER(github_name) LIKE '%#{keyword}%'" \
                                   " OR LOWER(stackoverflow_name) LIKE '%#{keyword}%'")
                                   .order('snippets.created_at DESC').all
      else
        @snippets = snippets.where("LOWER(title LIKE '%#{keyword}%'" \
                                   " OR LOWER(code) LIKE '%#{keyword}%'" \
                                   " OR LOWER(display_name) LIKE '%#{keyword}%'" \
                                   " OR LOWER(github_name) LIKE '%#{keyword}%'" \
                                   " OR LOWER(stackoverflow_name) LIKE '%#{keyword}%'")
                            .order('snippets.created_at DESC').all
      end
    end
  end

  # GET /snippets/1
  # GET /snippets/1.json
  def show
    @current_profile = Profile.find_by_user_id(current_user.id)
    puts @current_profile.nil?
  end

  # GET /snippets/new
  def new
    @snippet = Snippet.new
  end

  # GET /snippets/1/edit
  def edit
  end

  # POST /snippets
  # POST /snippets.json
  def create
    @snippet = Snippet.new(snippet_params)

    respond_to do |format|
      if @snippet.save
        format.html { redirect_to "/snippets/#{@snippet.id}", notice: 'Snippet was successfully created.' }
        format.json { render :show, status: :created, location: @snippet }
      else
        format.html { render :new }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /snippets/create_comment
  def create_comment
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to "/snippets/#{@comment.snippet_id}", notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snippets/1
  # PATCH/PUT /snippets/1.json
  def update
    respond_to do |format|
      if @snippet.update(snippet_params)
        format.html { redirect_to "/snippets/#{@snippet.id}", notice: 'Snippet was successfully updated.' }
        format.json { render :show, status: :ok, location: @snippet }
      else
        format.html { render :edit }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.json
  def destroy
    @snippet.destroy
    respond_to do |format|
      format.html { redirect_to '/snippets', notice: 'Snippet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snippet
      now = Date.today
      @snippet = Snippet.find(params[:id])
      @user = User.find(@snippet.user_id)
      @profile = Profile.find_by_user_id(@snippet.user_id)
      comments = Comment.where(:snippet_id => @snippet.id).all
      @comments = comments.joins("INNER JOIN users ON comments.user_id = users.id")
                          .joins("INNER JOIN profiles ON users.id = profiles.user_id")
                          .select("comments.id, comments.comment_body, comments.created_at, " \
                                  "comments.user_id, users.email, profiles.display_name, " \
                                  "profiles.github_name, profiles.stackoverflow_name, " \
                                  "profiles.avatar_url, profiles.avatar_url_source")

      @created_days_ago = (now - @snippet.created_at.to_date).to_i
      @updated_days_ago = (now - @snippet.updated_at.to_date).to_i
      @avatar = @profile.avatar_url

      @reputation = {}
      @comments.each do |comment|
        reputation = get_reputation_stats(comment.user_id)
        @reputation[comment.user_id] = reputation
      end
    end

    def get_reputation_stats user_id
      settings = {
        "github_api_user" => ENV['GITHUB_API_USER'],
        "github_api_token" => ENV['GITHUB_API_TOKEN'],
        "stackoverflow_key" => ENV['STACKOVERFLOW_KEY']
      }
      external_info = ExternalUserInfoAdapter.instance()
      external_info.set_settings(settings)
      return external_info.get_user_reputation(user_id)
    end

    # Only allow a list of trusted parameters through.
    def snippet_params
      params.require(:snippet).permit(:title, :code, :user_id)
    end

    def comment_params
      params.require(:comment).permit(:comment_body, :snippet_id, :user_id)
    end
end

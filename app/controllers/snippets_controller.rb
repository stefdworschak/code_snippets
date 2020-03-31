require 'uri'
class SnippetsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin, :only => [:edit, :destroy]
  before_action :set_snippet, only: [:show, :edit, :update, :destroy]

  def ensure_admin
    puts "IS ADMIN?"
    puts current_user.admin?
    unless current_user && current_user.admin?
      render :text => "Access Error Message", :status => :unauthorized
    end
  end

  # GET /snippets
  # GET /snippets.json
  def index
    if not params.has_key?(:search)
      snippets = Snippet.order('created_at DESC').all
      @snippets = snippets.joins("INNER JOIN 'users' ON 'snippets'.'user_id' = 'users'.'id'")
                          .joins("INNER JOIN 'profiles' ON  'users'.'id' = 'profiles'.'user_id'")
                          .select('snippets.*, users.*, profiles.*')
    else 
      search = params[:search]
      search_type = search[0]
      keyword = URI.decode(search[1,search.length])
      if search_type == ':'
        @snippets = Snippet.where("title LIKE '%#{keyword}%' OR code LIKE '%#{keyword}%'").order('created_at DESC').all
      elsif search_type == '#'
        @snippets = Snippet.order('created_at DESC').all
      elsif search_type == '@'
        profile = Profile.where("firstname LIKE '%#{keyword}%' OR lastname LIKE '%#{keyword}%'")
        @snippets = Snippet.where(:user_id => profile).all
      else
      end
    end
  end

  # GET /snippets/1
  # GET /snippets/1.json
  def show
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
        format.html { redirect_to @snippet, notice: 'Snippet was successfully created.' }
        format.json { render :show, status: :created, location: @snippet }
      else
        format.html { render :new }
        format.json { render json: @snippet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /snippets/1
  # PATCH/PUT /snippets/1.json
  def update
    respond_to do |format|
      if @snippet.update(snippet_params)
        format.html { redirect_to @snippet, notice: 'Snippet was successfully updated.' }
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
      format.html { redirect_to snippets_url, notice: 'Snippet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_snippet
      @snippet = Snippet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def snippet_params
      params.require(:snippet).permit(:title, :code, :user_id)
    end
end

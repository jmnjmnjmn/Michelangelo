class AudiosController < ApplicationController
  before_action :set_audio, only: [:show, :edit, :update, :destroy]
  before_action :all_audios, only: [:index, :create]
  respond_to :html, :js  

  # GET /audios
  # GET /audios.json
  def index
    # @audios = Audio.all
    @commenttype = 1
    @liketype = 1

    current_user = User.find(session[:user_id])
    @audios = current_user.discover_audios.includes(:comments, :likes).paginate(:page => params[:page], per_page: 8)

    respond_to do |format|
      format.html
      format.js
    end    
  end

  # GET /audios/1
  # GET /audios/1.json
  def show
  end

  def audioallcomments
    @audio_id = params[:id]
    @comments = Audio.find(params[:id]).audioallcomments
  end

  # GET /audios/new
  def new
    @audio = Audio.new
  end

  # GET /audios/1/edit
  def edit
  end

  # POST /audios
  # POST /audios.json
  def create
    @audio = Audio.new(audio_params)

    @audio.uid = session[:user_id]

    respond_to do |format|
      if @audio.save
        format.html { redirect_to audios_path }
        format.json { render action: 'show', status: :created, location: @audio }
      else
        format.html { render action: 'new' }
        format.json { render json: @audio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /audios/1
  # PATCH/PUT /audios/1.json
  def update
    respond_to do |format|
      if @audio.update(audio_params)
        format.html { redirect_to @audio, notice: 'Audio was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @audio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audios/1
  # DELETE /audios/1.json
  def destroy

    if postComments = Unreadcomment.where(:post_id => @audio.id, :commenttype => 1)
      Unreadcomment.delete(postComments)
    end

    if postLikes = Unreadlike.where(:post_id => @audio.id, :liketype => 1)
      Unreadlike.delete(postLikes)
    end

    @audio.destroy
    respond_to do |format|
      format.html { redirect_to audios_url }
      format.json { head :no_content }
    end
  end

    # PUT
  def like 
    @audio = Audio.find(params[:id])
    current_user = User.find(session[:user_id])
    current_user.like(@audio, params[:liketype])

      @host = @audio.uid
      if (@host != current_user.id)
        Unreadlike.create(:post_id => @audio.id, :user_id => @host, :liker => current_user.id, :liketype => 1)
      end

    if request.xhr?
      render json: { count: @audio.audiolikecount, id: params[:id] }
    else
      redirect_to @audio
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = Audio.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audio_params
      params.require(:audio).permit(:comment, :uid, :audioFile)
    end

    def all_audios
      current_user = User.find(session[:user_id])
      @audios = current_user.discover_audios
    end
end

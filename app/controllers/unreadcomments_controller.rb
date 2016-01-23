class UnreadcommentsController < ApplicationController
  before_action :set_unreadcomment, only: [:show, :edit, :update, :destroy]

  # GET /unreadcomments
  # GET /unreadcomments.json
  def index
    @unreadcomments = Unreadcomment.all
  end

  # GET /unreadcomments/1
  # GET /unreadcomments/1.json
  def show
  end

  # GET /unreadcomments/new
  def new
    @unreadcomment = Unreadcomment.new
  end

  # GET /unreadcomments/1/edit
  def edit
  end

  def view_comment
    @thisComment = Unreadcomment.find(params[:id])

    if @thisComment.commenttype == 0
      @commenttype = 0
      @liketype = 0
      @music = Music.find(@thisComment.post_id)
    else
      @commenttype = 1
      @liketype = 1
      @audio = Audio.find(@thisComment.post_id)
    end

    Unreadcomment.delete(params[:id])

  end


  # POST /unreadcomments
  # POST /unreadcomments.json
  def create
    @unreadcomment = Unreadcomment.new(unreadcomment_params)

    respond_to do |format|
      if @unreadcomment.save
        format.html { redirect_to @unreadcomment, notice: 'Unreadcomment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @unreadcomment }
      else
        format.html { render action: 'new' }
        format.json { render json: @unreadcomment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unreadcomments/1
  # PATCH/PUT /unreadcomments/1.json
  def update
    respond_to do |format|
      if @unreadcomment.update(unreadcomment_params)
        format.html { redirect_to @unreadcomment, notice: 'Unreadcomment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unreadcomment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unreadcomments/1
  # DELETE /unreadcomments/1.json
  def destroy
    @unreadcomment.destroy
    respond_to do |format|
      format.html { redirect_to unreadcomments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unreadcomment
      @unreadcomment = Unreadcomment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unreadcomment_params
      params.require(:unreadcomment).permit(:comment_id, :post_id, :user_id, :commenter, :commenttype)
    end
end

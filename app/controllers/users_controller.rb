class UsersController < ApplicationController
  skip_before_action :authorize
  before_action :set_user, only: [:edit, :show, :friends, :update, :destroy, :newfriend, :mytimeline, :audiotimeline]
  before_action :set_current_user, only: [:index, :show, :friends, :newfriend, :mytimeline, :audiotimeline]

  def index

    if params[:search]
      @searchedUsers = User.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], per_page: 8)
    else
      @searchedUsers = User.order("created_at DESC").paginate(:page => params[:page], per_page: 8)
    end    

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @mymusics = Music.where(:uid => params[:id]).order('created_at DESC')
    @date = @user.created_at.strftime('%B %d, %Y')
  end

  def friends
    @friends = @user.friends.paginate(:page => params[:page], per_page: 10).order('created_at DESC')
  end


  def mytimeline
    @mymusics = Music.where(:uid => params[:id]).paginate(:page => params[:page], per_page: 8).order('created_at DESC')

    @commenttype = 0
    @liketype = 0
    respond_to do |format|
      format.html
      format.js
    end
  end

  def audiotimeline
    # @current_user = User.find(session[:user_id])
    @myaudios = Audio.where(:uid => params[:id]).paginate(:page => params[:page], per_page: 8).order('created_at DESC')

    @commenttype = 1
    @liketype = 1
    respond_to do |format|
      format.html
      format.js
    end
  end


  def newfriend
    @friends = @user.friends   
  end


  def notification
    @mynotification = Unreadcomment.where(:user_id => params[:id]).order('created_at DESC')
  end
  

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    @user.update_attribute(:updated_at, Time.now)

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      flash[:notice] = "User #{@user.name} deleted"
    rescue StandardError => e
      flash[:notice] = e.message
    end 
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def contact
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_current_user
      @current_user = User.find(session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
        params.require(:user).permit(:name, :password, :password_confirmation, :gender, :age, :interest, :picurl, :image)
    end
end

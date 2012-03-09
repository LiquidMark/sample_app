class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :not_signed_in_user, only: [:create, :new]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    #redirect_to(root_path) if signed_in_user 
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Liquid Autos!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # @user has been set by correct_user before_filter
  end

  def update
    # @user has been set by correct_user before_filter
    if @user.update_attributes(params[:user])
      # Handle a successful update. Re-sign-in the user so his
      # cookies match the new info created by saving the User:
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit' # errors are in flash from update_attributes
    end
  end

  def destroy
    user_to_be_destroyed = User.find(params[:id])
    if current_user?(user_to_be_destroyed)
      flash[:error] = "You may not delete your own account."
    else
      user_to_be_destroyed.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end  

  private

    def signed_in_user
      store_location # Why isn't in a more global place?
      redirect_to signin_path, notice: "Please sign in to access this page." unless signed_in?
    end

    def not_signed_in_user
      redirect_to root_path, notice: "You are signed in, so there is no need to create a new account." unless !signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
end

class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
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
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update. Re-sign-in the user so his
      # cookies match the new info created by saving the User:
      sign_in @user
      redirect_to @user, notice: "Profile updated"
    else
      render 'edit' # errors are in flash from update_attributes
    end
  end

end

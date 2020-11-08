class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to the bog #{@user.username} , you are successfully signed up"
      redirect_to root_path
    else
      if User.find_by(username: @user.username)
        flash[:error] = "Username is already taken"
      elsif @user.username.length < 3 
        flash[:error] = "Username cant be less than 3 characters"
      elsif @user.password == nil 
        flash[:error] = "Password can't be blank"
      end
      render 'new'
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end


  def user_params
    params.require(:user).permit(:username, :email, :password) 
  end

  def require_same_user 
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own account"
      redirect_to @user
    end
  end

end

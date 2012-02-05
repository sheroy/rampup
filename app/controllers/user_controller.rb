class UserController < ApplicationController
  def signin
    user = User.authenticate(params[:username], params[:password])
    if user.nil? 
      flash[:login_error]="Username or Password Invalid"
      redirect_to :controller=>'user',:action=>'login'
    else
      session[:cas_user] = user.username
      role_home_path(user.role)

    end
  end      

  def role_home_path(role)
    if role == "admin" || role == "superadmin"
      redirect_to admin_home_path
    else
      redirect_to employee_home_path
    end
  end


  def login
    if isLoggedIn
      flash[:notice]='Already Logged in'
      redirect_to home_path
    end
  end
end
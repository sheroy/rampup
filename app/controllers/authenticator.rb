module CASAuthenticator
  def self.included(base)
    base.before_filter RubyCAS::Filter, :current_user
    base.helper_method :current_user
  end

  def logout
    @current_user =  nil
    RubyCAS::Filter.logout(self)
  end

  def current_user
    if isLoggedIn
      return @current_user
    end
    @current_user = User.find_by_username(session[:cas_user])
     if(@current_user.nil?)
       return @current_user = User.employeeUser(session[:cas_user])
     end
  end
end

module LocalAuthenticator
  def self.included(base)
    base.append_before_filter :current_user, :authenticator, :except => %w{user login user signup user signin}
    base.helper_method :current_user
  end

  def logout
    session[:cas_user] = nil
    @current_user = nil
    redirect_to :controller=>'user', :action=>'login'
  end

  def current_user
    if isLoggedIn
      return @current_user
    end
    puts session[:cas_user]
    return @current_user = User.find_by_username(session[:cas_user])
  end

  private
  def authenticator
    if isLoggedIn
      current_user
    else
      redirect_to :controller=>'user', :action=>'login'
    end
  end
end

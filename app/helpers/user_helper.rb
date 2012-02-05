module UserHelper 
  def current_user
    if isLoggedIn
      return @current_user
    end
    puts session[:cas_user]
    return @current_user = User.find_by_username(session[:cas_user])
  end
end 

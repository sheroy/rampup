class ApplicationController < ActionController::Base
  layout 'master'
  require 'authenticator'
  print "Here"
  include (AuthenticationConfig[:enable_cas] == true ? CASAuthenticator : LocalAuthenticator)

  helper :all
  protect_from_forgery # :secret => 'e7aa2267d9a05e4a7c391946da95b6a2'

  def isLoggedIn
    return !@current_user.nil?
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_404
    rescue_from RuntimeError do |error|
      logger.error "RuntimeError"
      render_500
    end

    rescue_from Exception do |exception|
      logger.error exception.backtrace
      render_500
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if can? :manage, User
      redirect_to admin_home_path
    else
      redirect_to employee_home_path
    end
  end


  private
  def render_404
    render :template => "error_pages/error_404", :layout => 'master', :status => :not_found
  end

  def render_500
    render :template => "error_pages/error_500", :layout => 'master', :status => :internal_server_error
    logger.error
  end
end

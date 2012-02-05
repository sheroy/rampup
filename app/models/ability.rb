class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new #Logged out

    if user.role?("admin")
      can :manage, :all
      cannot :manage, :superadmin
    elsif user.role?("superadmin")
      can :manage, :all
    elsif user.role?("employee")
      can :read, Profile do |profile|
        profile.try(:email_id) == user.username
      end
      can :show_insurance, Profile do |profile|
        profile.try(:email_id) == user.username
      end
    end

  end
end
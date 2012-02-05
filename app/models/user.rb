require 'digest/sha2'
class User < ActiveRecord::Base
  validates_presence_of :username,:message => 'cant be blank'
  validates_uniqueness_of :username,:message => 'is already taken'

  def self.is_valid_password?(password) 
    return false if password.nil?
    return false if password.blank?
    return false if password.length < 6
    return true
  end

  def self.employeeUser name
    return User.new(:role=>"employee",:username=>name)
  end

  def self.isAdmin(current_user)
    if(current_user.nil?)
      return false
    end
    return current_user.role == "admin"
  end
  
  def self.isSuperAdmin(current_user)
    if current_user.nil?
      return false
    end
    return current_user.role == "superadmin"
  end

  def role?(role)
    if self.nil?
      return false
    end

    return self.role == role
  end


  def password=(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
  def self.authenticate(username, password)
    user = User.find(:first,:conditions => [ ' username = ?' , username])
    user = nil if user.blank? || valid_password(password, user.password_hash, user.password_salt)
    user
  end
  
  def self.valid_password(password, password_hash, password_salt)
    Digest::SHA256.hexdigest(password + password_salt) != password_hash
  end
  
end

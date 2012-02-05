class Signature < ActiveRecord::Base
  validates_presence_of :name,:signature => 'cannot be blank'
  validates_uniqueness_of :name,:signature => 'is already taken'
end

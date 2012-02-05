class Visa < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :category
end

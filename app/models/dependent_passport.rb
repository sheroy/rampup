class DependentPassport < ActiveRecord::Base
  validates_presence_of :number, :date_of_issue, :date_of_expiry, :place_of_issue, :nationality, :profile_id, :name
  belongs_to :profile
  has_many :dependent_visas,:dependent => :destroy
end

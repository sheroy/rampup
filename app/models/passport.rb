class Passport < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :number, :date_of_issue, :date_of_expiry, :place_of_issue, :nationality, :profile_id
end

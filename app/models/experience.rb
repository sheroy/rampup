class Experience < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :technology
  validates :duration, :numericality => { :greater_than => 0 }

  def self.max_count_of_experience_among_all_profiles
    max = Experience.count(:group => 'profile_id').values.max
    max.nil? ? 0 : max
  end
end

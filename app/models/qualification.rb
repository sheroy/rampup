class Qualification < ActiveRecord::Base
  belongs_to :profile
  validates_presence_of :college, :degree
  #  def self.qualification_category_in_location(category,location)
  #    qualifications=[]
  #    tmp= Qualification.all(:conditions=>{:category=>category})
  #    tmp.each do |qualification|
  #      qualifications<<qualification if qualification.profile.location==location && qualification.profile.last_day==nil
  #    end
  #    return qualifications
  #  end

  def self.max_count_of_qualification_among_all_profiles
    max = Qualification.count(:group=>'profile_id').values.max
    max.nil? ? 0 : max
  end
end

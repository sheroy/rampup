class Life<Dependent
  validates_presence_of :name,:relationship,:percentage
  validates_numericality_of :percentage, :less_than => 101, :greater_than=>1, :allow_blank=> false, :message => "total percentage should be less than 100% and greater than 1%"

  def self.max_count_of_life_insurance_among_all_profiles
    max = Life.count(:group=>'profile_id').values.max
    max.nil? ? 0 : max
  end
end
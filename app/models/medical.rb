class Medical<Dependent
  validates_presence_of :name, :relationship, :date_of_birth
  belongs_to :profile

  def age
    return ((DateTime.now.to_date - date_of_birth.to_date).days / 365.days).to_i unless date_of_birth.nil?
  end

  def self.max_count_of_medical_dependent_among_all_profiles
    max = Medical.count(:group=>'profile_id').values.max
    max.nil? ? 0 : max
  end
end
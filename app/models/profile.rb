require 'will_paginate/array'

class Profile < ActiveRecord::Base

  def head_count
    attributes['head_count']
  end

  def experience
    attributes['experience']
  end

  def passport_number
    attributes['passport_number']
  end

  def passport_expiry
    attributes['passport_expiry']
  end

  def visa_category
    attributes['visa_category']
  end

  def visa_expiry
    attributes['visa_expiry']
  end

  def start_date
    attributes['start_date']
  end

  def location_id
    attributes['location_id']
  end

  has_many :employee_checklist_submitteds ,:dependent=>:destroy, :autosave => true
  has_many :qualifications, :dependent=>:destroy, :autosave=>true, :order => "graduation_year DESC"
  has_many :experiences, :dependent=>:destroy, :autosave=>true, :order => "last_used DESC"
  has_one :passport, :dependent=>:destroy, :autosave=>true
  has_many :visas, :dependent=>:destroy, :autosave=>true
  has_many :dependents, :dependent=>:destroy, :autosave=>true
  has_one :picture, :dependent=>:destroy, :autosave=>true
  has_one :profile_picture, :dependent=>:destroy, :autosave=>true
  has_one :location
  has_many :medicals, :dependent=>:destroy, :autosave=>true
  has_many :lives, :dependent => :destroy, :autosave=>true
  has_many :dependent_passports, :dependent=>:destroy, :autosave=>true
  has_many :attached_documents, :dependent=>:destroy, :autosave=>true
  validate :validate_resignation_date


  validates_presence_of :name,:surname,:title,:date_of_birth,:email_id,
    :marital_status,:personal_email_id,:blood_group,:emergency_contact_person,
    :guardian_name,:date_of_joining,:years_of_experience,:location_id,
    :temporary_address_line1,:temporary_city, :temporary_state,:temporary_pincode,
    :permanent_address_line_1,:permanent_city,:emergency_contact_number,
    :permanent_state,:permanent_pincode,:pan_no, :qualifications,
    :message=>'mandatory'
  validates_numericality_of :permanent_pincode,:temporary_pincode,:emergency_contact_number,:permanent_phone_number,:temporary_phone_number,
    :message=>'should be a number',:allow_nil=>true, :allow_blank=>true
  validates_uniqueness_of :employee_id ,:allow_nil=>true, :allow_blank=>true
  validates_length_of :employee_id,:is=>5, :allow_nil=>false, :allow_blank=>false,
    :message=>'should be of length 5'
  validates_numericality_of :employee_id,
                            :message=>'should be a number', :allow_nil=>false, :allow_blank=>false
  validates_length_of :permanent_pincode, :temporary_pincode, :is => 6,
                      :message=>'should be of length 6', :allow_nil=>true, :allow_blank=>true
  validates_numericality_of :years_of_experience,
                            :message=>'not a valid number', :allow_blank=>true, :allow_nil=>true
  validates_associated :experiences,:passport,:visas,:qualifications,:employee_checklist_submitteds,:picture,:medicals,:lives,:dependent_passports
  validates_as_email :personal_email_id

  def validate_resignation_date
    if (self.last_day && (self.last_day < self.date_of_joining))
      errors.add(:last_day, "cannot be less than date of joining")
    end
  end

  def past_experience_in(technology)
    sum = 0
    self.experiences.each do |experience|
      if experience.technology == technology
        sum = sum + experience.duration
      end
    end
    return (sum*30).days
  end

  def has_past_experience_in(technology)
    self.experiences.each do |experience|
      if experience.technology==technology
        return true
      end
    end
    return false
  end

  def self.with_no_pictures
    return Profile.find_by_sql("select * from profiles where last_day is null and employee_id is not NULL and id not in (select profile_id from pictures where profile_id is not NULL)")
  end


  def self.create_or_update(attributes, validate)
    profile = Profile.find_or_initialize_by_employee_id(attributes[:employee_id])
    profile.attributes = attributes
    profile.qualifications << ModelFactory.create_qualification()
    profile[:completed] = validate
    profile.type = attributes[:type]
    profile.valid?
    if (profile.errors[:employee_id].blank?)
      validate ? [profile.save, profile] : [profile.save(:validate => false), profile]
    else
      validate = [false, profile]
    end
  end

  def mark_as_complete
    self.update_attributes(:completed=>true)
  end

  def self.role_in_location(role,location_id)
    Profile.all(:conditions=>{:title=>role,:location_id=>location_id, :last_day=>nil})
  end

  def self.head_count_in_location(employee_type,location_id)
    Profile.all(:conditions=>{:type=>employee_type,:location_id=>location_id, :last_day=>nil})
  end

  def self.qualification_category_in_location
    Profile.find_by_sql(%{SELECT count(*) AS head_count,profiles.location_id,qualifications.category
                               FROM profiles
                               JOIN qualifications
                               ON profiles.id=qualifications.profile_id
                               WHERE profiles.last_day IS NULL
                               AND qualifications.category IS NOT NULL
                               GROUP BY profiles.location_id,qualifications.category
                               ORDER BY profiles.location_id})
  end

  def self.role_and_location_wise_breakdown
    Profile.find_by_sql(%{SELECT count(*) AS head_count,location_id,title
                          FROM profiles
                          WHERE last_day IS NULL
                          AND title IS NOT NULL
                          AND location_id IS NOT NULL
                          GROUP BY location_id,title
                          ORDER BY title})
  end

  def self.find_search_parameters(search_parameter)
    Profile.find_by_sql("SELECT profiles.*  FROM profiles where lower(name) like lower('%#{search_parameter}%') or lower(surname) like lower('%#{search_parameter}%')
                      or lower(common_name) like lower('%#{search_parameter}%') or lower(title) like lower('%#{search_parameter}%')
                      or lower(location_id) like lower('%#{search_parameter}%') or employee_id like '#{search_parameter}'")
  end

  def self.get_profile_within_the_date_range(start_date,end_date)
    profiles=Profile.find_by_sql(["select * from profiles where date_of_joining>=? and date_of_joining<=? and last_day is NULL and employee_id is
        NOT NULL",start_date,end_date])
  end

  def self.get_exit_employees_within_given_date_range(start_date,end_date)
    profiles=Profile.find_by_sql(["select * from profiles where last_day>=? and last_day<=? and last_day is NOT NULL and employee_id is
        NOT NULL",start_date,end_date])
  end

  def self.list_of_exit_employees
    Profile.find_by_sql("select * from profiles where last_day is NOT NULL and employee_id is NOT NULL");
  end

  def self.get_employees_with_no_passport
    return Profile.find_by_sql("select * from profiles where id not in(select profile_id from passports where number is not null and profile_id is not null) and employee_id is NOT NULL and last_day is NULL")
  end

  def self.get_birthday_babies(month,location)
    profiles=Profile.find_by_sql(["SELECT *from profiles where month(date_of_birth)=? and last_day is NULL and location_id=? order by day(date_of_birth)",month,location])
  end

  scope :expiring_passports, {:joins => :passport, :conditions => ["passports.date_of_expiry <= ? and passports.date_of_expiry > ?", Date.today + 8.months, Date.today]}

  def self.get_employees_whose_passports_have_expired
    profiles=Profile.find_by_sql('select profiles.* from profiles
                                  JOIN passports
                                  on profiles.id= passports.profile_id
                                  where profiles.id in (select profile_id from passports where datediff(curdate(),date_of_expiry)>=0 and number is not NULL and date_of_expiry is NOT NULL) and last_day is NULL
                                  ORDER BY date_of_expiry')
  end

  def self.immigration_advanced_search(location_in, title, name, visa,page,type)
    location = location_in.blank? ? Location.get_all_location_ids : location_in.paginate.to_a
    @allTitles = Title.getAllSortedTitles
    title = title.blank? ? @allTitles : title.paginate.to_a
    name = name.blank? ? "%%" : "%#{name}%"

    if (visa=='any')
      visa='%%'
      @sql_query = %{SELECT profiles.*,v.category as visa_category,v.expiry_date as visa_expiry,p.number as passport_number,
                                   p.date_of_expiry as passport_expiry FROM profiles
                                   inner join passports p on p.profile_id=profiles.id
                                   inner join visas v on v.profile_id=profiles.id
                                   WHERE profiles.common_name like ? and location_id in (?) and title in (?) and v.category like ?
                                   AND last_day is NULL and employee_id is not null order by date_of_joining DESC,employee_id DESC }
    else
      visa = visa.blank? ? "%%" : "%#{visa}%"
      @sql_query = %{SELECT profiles.*,v.category as visa_category,v.expiry_date as visa_expiry,p.number as passport_number,
                                   p.date_of_expiry as passport_expiry FROM profiles
                                   inner join passports p on p.profile_id=profiles.id
                                   inner join visas v on v.profile_id=profiles.id
                                   WHERE profiles.common_name like ? and location_id in (?) and title in (?) and coalesce(v.category,0) like ?
                                   AND last_day is NULL and employee_id is not null order by date_of_joining DESC,employee_id DESC }
    end

    if (type=='paginate')
      profiles||=Profile.find_by_sql([@sql_query, name, location, title, visa])
      return profiles.paginate(:page=>page, :per_page=>10)
    else
      profiles||=Profile.find_by_sql([@sql_query, name, location, title, visa])
      return profiles
    end
  end

  def self.set_column_mappings
    @@column_mapping = {}
    @@column_mapping["Profile"] = {}
    @@column_mapping["Profile"]["employee_id"] = "Employee ID"
    @@column_mapping["Profile"]["name"] = "First Name"
    @@column_mapping["Profile"]["surname"] = "Last Name"
    @@column_mapping["Profile"]["location"] = "Home Office"
    @@column_mapping["Personal_Details"] = {}
    @@column_mapping["Personal_Details"]["title"] = "Role"
    @@column_mapping["Personal_Details"]["gender"] = "Gender"
    @@column_mapping["Personal_Details"]["marital_status"] = "Marital Status"
    @@column_mapping["Personal_Details"]["email_id"] = "Email ID"
    @@column_mapping["Personal_Details"]["personal_email_id"] = "Personal Email ID"
    @@column_mapping["Personal_Details"]["date_of_birth"] = "Date of Birth"
    @@column_mapping["Personal_Details"]["date_of_joining"] = "Date of Joining"
    @@column_mapping["Personal_Details"]["years_of_experience"] = "Experience prior to TW"
    @@column_mapping["Personal_Details"]["blood_group"] = "Blood Group"
    @@column_mapping["Personal_Details"]["emergency_contact_person"] = "Emergency Contact Person"
    @@column_mapping["Personal_Details"]["emergency_contact_number"] = "Emergency Contact Number"
    @@column_mapping["Passport"] = {}
    @@column_mapping["Passport"]["number"] = "Passport Number"
    @@column_mapping["Passport"]["date_of_issue"] = "Date of Issue"
    @@column_mapping["Passport"]["date_of_expiry"] = "Date of Expiry"
    @@column_mapping["Passport"]["place_of_issue"] = "Place of Issue"
    @@column_mapping["Passport"]["nationality"] = "Nationality"
    @@column_mapping["Passport"]["profile_id"] = "Profile ID"
    @@column_mapping["Financial"] = {}
    @@column_mapping["Financial"]["account_no"] = "Bank Account No"
    @@column_mapping["Financial"]["pan_no"] = "PAN No"
    @@column_mapping["Financial"]["EPF_no"] = "EPF No"
    @@column_mapping["Qualification"] = {}
    @@column_mapping["Qualification"]["graduation_year"] = "Year of Graduation"
    @@column_mapping["Qualification"]["category"] = "Category"
    @@column_mapping["Qualification"]["branch"] = "Branch"
    @@column_mapping["Qualification"]["college"] = "University"
    @@column_mapping["Qualification"]["degree"] = "Degree"
    @@column_mapping["Experience"] = {}
    @@column_mapping["Experience"]["technology"] = "Technology"
    @@column_mapping["Experience"]["last_used"] = "Last Used"
    @@column_mapping["Experience"]["duration"] = "Duration(months)"
    @@column_mapping["Medical_Insurance"] = {}
    @@column_mapping["Medical_Insurance"]["name"] = "Dependent Name"
    @@column_mapping["Medical_Insurance"]["relationship"] = "Relationship"
    @@column_mapping["Medical_Insurance"]["date_of_birth"] = "DOB"
    @@column_mapping["Medical_Insurance"]["age"] = "Age"
    @@column_mapping["Life_Insurance"] = {}
    @@column_mapping["Life_Insurance"]['name'] = "Beneficiary Name"
    @@column_mapping["Life_Insurance"]['relationship'] = "Relationship with Employee"
    @@column_mapping["Life_Insurance"]['percentage'] = "Percentage"
  end

  def self.get_customized_report(selected_columns = {})
    @report_header = []
    @report_data = {}
    set_column_mappings
    generate_default_report
    generate_personal_details(selected_columns['Personal Details'])
    generate_qualification_details(selected_columns['Qualification Details'])
    generate_experience_details(selected_columns['Experience Details'])
    generate_passport_details(selected_columns['Passport Details'])
    generate_life_insurance(selected_columns['Life Insurance'])
    generate_medical_insurance(selected_columns['Medical Insurance'])
    generate_financial_information(selected_columns['Financial Information'])
    remove_resigned_employees
    {:header => @report_header, :data => @report_data}
  end

  def self.remove_resigned_employees
    resigned_employees = Profile.all(:select => "id", :conditions => "last_day is not null").collect { |item| item.id }
    @report_data.delete_if do |key, value|
      resigned_employees.include? key
    end
  end

  def self.generate_default_report
    @report_header.push('Employee ID')
    @report_header.push('First Name')
    @report_header.push('Last Name')
    @report_header.push('Home Office')
    @profiles_default = Profile.all(:select =>"profiles.id,employee_id,profiles.name,surname,locations.name as location",
    :joins=>"LEFT JOIN locations ON locations.id = profiles.location_id")
    @profiles_default.each do |item|
      attrs = {}
      item.attribute_names.each do |name|
        if name != 'id'
          attrs[@@column_mapping["Profile"][name]] = item.read_attribute(name)
        end
        @report_data[item.id] = attrs
      end
    end
  end

  def self.get_key_by_value_in_column_mapping(value_to_find, mapping_group)
    @@column_mapping["#{mapping_group}"].find { |key, value| value == value_to_find }.first
  end

  def self.replace_select_conditions_by_term_in_mapping_group(selected_columns, select_conditions, mapping_group)
    selected_columns.each do |item|
      select_conditions[item] = get_key_by_value_in_column_mapping(item, mapping_group)
    end
    select_conditions
  end

  def self.merge_normal_column_data(data, name_of_column_profile_id, mapping_group)
    data.each do |item|
      attrs = {}
      #Following if condition is for discarding entries which do not have their profile_id
      if(!(item.read_attribute("#{name_of_column_profile_id}").nil?))
        item.attribute_names.each do |name|
          if name != "#{name_of_column_profile_id}"
            attrs[@@column_mapping["#{mapping_group}"][name]] = item.read_attribute(name).nil? ? "" :item.read_attribute(name)
          end
        end
      @report_data[item.attributes["#{name_of_column_profile_id}"]].merge! attrs unless attrs.nil?
      end
    end
  end

  def self.make_select_conditions(selected_columns, profile_id_column_name, mapping_group)
    select_conditions = selected_columns.join(',') + ", #{profile_id_column_name}"
    replace_select_conditions_by_term_in_mapping_group(selected_columns, select_conditions, "#{mapping_group}")
    select_conditions
  end

  def self.generate_financial_information(selected_columns)
    return if selected_columns.nil?
    add_normal_column_header(selected_columns)
    select_conditions = make_select_conditions(selected_columns, "id", "Financial")
    merge_normal_column_data(Profile.all(:select =>select_conditions), "id", "Financial")
  end

  def self.generate_passport_details(selected_columns)
    return if selected_columns.nil?
    add_normal_column_header(selected_columns)
    select_conditions = make_select_conditions(selected_columns, "profile_id", "Passport")
    merge_normal_column_data(Passport.all(:select =>select_conditions), "profile_id", "Passport")
  end

  def self.add_normal_column_header(header_names)
    header_names.each do |item|
      @report_header.push(item)
    end
  end

  def self.generate_personal_details(selected_columns)
    return if selected_columns.nil?
    add_normal_column_header(selected_columns)
    select_conditions = make_select_conditions(selected_columns, "id", "Personal_Details")
    merge_normal_column_data(Profile.all(:select =>select_conditions), "id", "Personal_Details")
  end

  def self.add_dynamic_column_header(count, header_names, prefix)
    count.times do |n|
      header_names.each { |item| @report_header.push("#{prefix}_#{n+1}_#{item}") }
    end
  end

  def self.merge_dynamic_column_data(data, mapping_group)
    data_group_by_profile = {}
    data.each do |item|
      if data_group_by_profile[item.profile_id].nil?
        data_group_by_profile[item.profile_id] = []
      end
      data_group_by_profile[item.profile_id] << item
    end
    data_group_by_profile.values.each do |employee_groups|
      employee_groups.each_with_index do |item, index|
        attrs = {}
        item.attribute_names.each do |name|
          if name != 'profile_id'
            attribute_name = "#{mapping_group}_"+(index+1).to_s+"_"+@@column_mapping["#{mapping_group}"][name]
            attrs[attribute_name] = item.read_attribute(name).nil? ? "" :item.read_attribute(name)
          end
        end
        @report_data[item.profile_id].merge! attrs unless attrs.nil?
      end
    end
  end

  def self.generate_qualification_details(selected_columns)
    return if selected_columns.nil?
    add_dynamic_column_header(Qualification.max_count_of_qualification_among_all_profiles,
                              selected_columns, "Qualification")
    select_conditions = make_select_conditions(selected_columns, "profile_id", "Qualification")
    merge_dynamic_column_data(Qualification.all(:select =>select_conditions), "Qualification")
  end

  def self.generate_experience_details(selected_columns)
    return if selected_columns.nil?
    add_dynamic_column_header(Experience.max_count_of_experience_among_all_profiles,
                              selected_columns, "Experience")
    select_conditions = make_select_conditions(selected_columns, "profile_id", "Experience")
    merge_dynamic_column_data(Experience.all(:select =>select_conditions), "Experience")
  end

  def self.generate_life_insurance(selected_columns)
    return if selected_columns.nil?
    add_dynamic_column_header(Life.max_count_of_life_insurance_among_all_profiles,
                              selected_columns, "Life_Insurance")
    select_conditions = make_select_conditions(selected_columns, "profile_id", "Life_Insurance")
    merge_dynamic_column_data(Life.all(:select =>select_conditions), "Life_Insurance")
  end

  def self.change_age_to_complex_sql_to_compute_age_dynamically(select_conditions)
    if select_conditions.include? 'age'
      select_conditions['age'] = "DATE_FORMAT(FROM_DAYS(to_days(now()) - to_days(date_of_birth)),'%Y') + 0 AS age"
    end
  end

  def self.generate_medical_insurance(selected_columns)
    return if selected_columns.nil?
    add_dynamic_column_header(Medical.max_count_of_medical_dependent_among_all_profiles,
                              selected_columns, "Medical_Insurance")
    select_conditions = make_select_conditions(selected_columns, "profile_id", "Medical_Insurance")
    change_age_to_complex_sql_to_compute_age_dynamically(select_conditions)
    merge_dynamic_column_data(Medical.all(:select =>select_conditions), "Medical_Insurance")
  end

  def get_total_experience_duration_by_name(technology, id)
    tech_experience ||= Profile.find_by_sql("SELECT SUM(duration) as duration, last_used from experiences where profile_id = #{id} and technology = '#{technology}' LIMIT 1")
    return tech_experience
  end
  
  def has_valid_qualifications?
    self.qualifications.size != 0      
  end

  def get_other_technologies_experience_by_profile_id(id)
    tech_experience ||= Profile.find_by_sql("SELECT technology, duration, last_used from experiences where profile_id = #{id} AND technology <> 'ruby' AND technology <> 'java' AND technology <> '.net'")
    return tech_experience
  end

end

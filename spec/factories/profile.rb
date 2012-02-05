Factory.define :profile do |f|
  f.sequence(:employee_id) {|n| n.to_s.rjust(5, '0')}
  f.sequence(:name) {|n| "Name #{n}" }
  f.surname 'S'
  f.common_name 'Mohan S'
  f.title 'Application Developer'
  f.gender 'female'
  f.marital_status 'single'
  f.permanent_address_line_1 'karur'
  f.permanent_address_line2 ' '
  f.permanent_address_line3 ' '
  f.permanent_city 'karur'
  f.permanent_state 'tamil nadu'
  f.permanent_pincode '123456'
  f.temporary_address_line1 'chennai'
  f.temporary_address_line2 ' '
  f.temporary_address_line3 ' '
  f.temporary_city 'chennai'
  f.temporary_state 'tamil nadu'
  f.temporary_pincode '123456'
  f.guardian_name 'niveditha'
  f.location_id "2"
  f.date_of_joining Time.now
  f.transfer_date Time.now
  f.transfer_from '1'
  f.transfer_to '2'
  f.date_of_birth Time.now
  f.years_of_experience 320
  f.email_id 'nivedis'
  f.personal_email_id 'aaa@gmail.com'
  f.permanent_phone_number "12345678"
  f.temporary_phone_number "12345678"
  f.blood_group "B+"
  f.pan_no "2428492"
  f.emergency_contact_person "xyz"
  f.emergency_contact_number "202984290"

  f.after_build do |profile|
      profile.qualifications = [Factory.build(:qualification, :profile => profile)]
  end

  f.completed true

end

Factory.define :incomplete_profile, :parent => :profile do |f|
  f.completed false
end

Factory.define :incomplete_profile_with_insurance, :parent => :profile do |f|
  f.after_build do |profile|
    profile.medicals = [Factory.build(:medical, :profile => profile)]
    profile.lives = [Factory.build(:life, :profile => profile)]
  end
  f.completed false
end



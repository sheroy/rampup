#require(File.join(Rails.root, 'vendor', 'gems', 'metric_fu-1.3.0', 'lib', 'metric_fu'))

namespace :db do
  task :populate => :environment do
    require 'populator'
    require 'faker'
    LOCATIONS=Location.all.collect { |location| location.id }
    CITY=Location.all.collect { |location| location.name }
    flag=false
    Profile.populate 70 do |profile1|
      profile1.employee_id = 10000+rand(9999)
      profile1.name = Faker::Name.first_name
      profile1.surname = Faker::Name.last_name
      profile1.title = Title.all.collect { |title| title.name }
      profile1.email_id = Faker::Name.first_name
      profile1.gender=['Male', 'Female']
      profile1.marital_status=['Single', 'Married', 'Others']
      profile1.guardian_name= Faker::Name.first_name
      profile1.location_id= LOCATIONS
      profile1.transfer_from= LOCATIONS
      profile1.transfer_to= LOCATIONS
      profile1.permanent_address_line_1=Faker::Address.street_name
      profile1.permanent_address_line2=Faker::Address.city
      profile1.permanent_address_line3=Faker::Address.state
      profile1.permanent_pincode = 100000 + rand(10000)
      profile1.permanent_city= CITY
      profile1.permanent_state = State.all.collect { |state| state.name }
      profile1.temporary_pincode = 100000 + rand(10000)
      profile1.temporary_address_line1=Faker::Address.street_name
      profile1.temporary_address_line2=Faker::Address.street_suffix
      profile1.temporary_address_line3=Faker::Address.city_prefix
      profile1.temporary_city= CITY
      profile1.temporary_state = State.all.collect { |state| state.name }
      profile1.temporary_pincode = 100000 + rand(10000)
      profile1.date_of_joining = ['08/08/2011'.to_date, '12/04/2010'.to_date, '05/09/2009'.to_date, '03/05/2010'.to_date]
      profile1.transfer_date =['08/08/2011'.to_date, '12/04/2010'.to_date, '05/09/2009'.to_date, '03/05/2010'.to_date]
      profile1.date_of_birth = ['08/08/1988'.to_date, '12/04/1978'.to_date, '05/09/1987'.to_date, '03/05/1985'.to_date]
      profile1.years_of_experience=rand(12)
      profile1.permanent_phone_number= 1 +rand(9999999998)
      profile1.temporary_phone_number= 1 +rand(9999999998)
      profile1.pan_no=100000+rand(7000)
      profile1.personal_email_id=Faker::Internet.email
      profile1.common_name=Faker::Name.name
      profile1.access_card_number = rand(999998)
      profile1.blood_group = ['A+', 'B+', 'O+']
      profile1.emergency_contact_person = Faker::Name.first_name
      profile1.emergency_contact_number=1 +rand(9999999998)
      profile1.account_no = 10000000000+rand(999999999)
      profile1.epf_no = 10000000000+rand(999999999)
      profile1.completed = 0;
      if flag==false
        flag=true
        profile1.email_id="employee"
      end

      Qualification.populate 3 do |qualification1|
        qualification1.profile_id = profile1.id
        qualification1.branch = Branch.all.collect { |branch| branch.name }
        qualification1.college= College.all.collect { |college| college.name }
        qualification1.graduation_year = ['2011', '2010', '2009', '2005']
        qualification1.degree= Degree.all.collect { |degree| degree.name }
        qualification1.category= Degree.all.collect { |degree| degree.category }
      end

      Experience.populate 3 do |experience|
        experience.profile_id = profile1.id
        experience.technology = SKILL_SET
        experience.last_used = ['08/08/2011'.to_date, '12/04/2010'.to_date, '05/09/2009'.to_date, '03/05/2010'.to_date]
        experience.duration = rand(50)

      end

      Passport.populate 1..1 do |passport|
        passport.profile_id = profile1.id
        passport.number = rand(8999999999)
        passport.date_of_issue = ['08/08/2011'.to_date, '12/04/2010'.to_date, '05/09/2009'.to_date, '03/05/2010'.to_date]
        passport.date_of_expiry = [Date.today, Date.tomorrow, Date.yesterday, 8.months.from_now, 9.months.from_now]
        passport.place_of_issue = ['lucknow', 'bangalore', 'delhi', 'bombay', 'chennai']
        passport.nationality = Country.all.collect { |country| country.name }

      end


      Dependent.populate 2 do |dependant1|
        dependant1.name = profile1.surname
        dependant1.relationship = 'Mother'
        dependant1.profile_id = profile1.id
        dependant1.date_of_birth = profile1.date_of_birth - 8000
        dependant1.percentage = 100
        dependant1.type = ['Life', 'Medical']
      end

      Visa.populate 1..1 do |visa|
        visa.profile_id = profile1.id
        visa.category = VisaCategory.all.collect { |category| category.name }
      end

    end
  end
end



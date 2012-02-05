class ChangeDateColumnsToDatetime < ActiveRecord::Migration
  def self.up
    change_column(:dependent_passports, :date_of_issue, :datetime)
    change_column(:dependent_passports, :date_of_expiry, :datetime)

    change_column(:dependent_visas, :appointment_date, :datetime)
    change_column(:dependent_visas, :issue_date, :datetime)
    change_column(:dependent_visas, :expiry_date, :datetime)
    change_column(:dependent_visas, :date_of_return, :datetime)
    change_column(:dependent_visas, :travel_by, :datetime)

    change_column(:dependents, :date_of_birth, :datetime)
    
    change_column(:experiences, :last_used, :datetime)
    
    change_column(:passports, :date_of_issue, :datetime)
    change_column(:passports, :date_of_expiry, :datetime)

    change_column(:profiles, :date_of_joining, :datetime)
    change_column(:profiles, :transfer_date, :datetime)
    change_column(:profiles, :date_of_birth, :datetime)
    change_column(:profiles, :last_day, :datetime)


    change_column(:visas, :appointment_date, :datetime)
    change_column(:visas, :issue_date, :datetime)
    change_column(:visas, :expiry_date, :datetime)
    change_column(:visas, :date_of_return, :datetime)
    change_column(:visas, :travel_by, :datetime)
  end

  def self.down
    change_column(:dependent_passports, :date_of_issue, :date)
    change_column(:dependent_passports, :date_of_expiry, :date)

    change_column(:dependent_visas, :appointment_date, :date)
    change_column(:dependent_visas, :issue_date, :date)
    change_column(:dependent_visas, :expiry_date, :date)
    change_column(:dependent_visas, :date_of_return, :date)
    change_column(:dependent_visas, :travel_by, :date)

    change_column(:dependents, :date_of_birth, :date)
    
    change_column(:experiences, :last_used, :date)
    
    change_column(:passports, :date_of_issue, :date)
    change_column(:passports, :date_of_expiry, :date)

    change_column(:profiles, :date_of_joining, :date)
    change_column(:profiles, :transfer_date, :date)
    change_column(:profiles, :date_of_birth, :date)
    change_column(:profiles, :last_day, :date)


    change_column(:visas, :appointment_date, :date)
    change_column(:visas, :issue_date, :date)
    change_column(:visas, :expiry_date, :date)
    change_column(:visas, :date_of_return, :date)
    change_column(:visas, :travel_by, :date)
  end
end

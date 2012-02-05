class ChangeDateTimeColumnBackToDate < ActiveRecord::Migration
  def self.up
    change_column(:profiles, :date_of_joining, :date)
    change_column(:profiles, :date_of_birth, :date)

    change_column(:passports, :date_of_issue, :date)
    change_column(:passports, :date_of_expiry, :date)

    change_column(:dependent_passports, :date_of_issue, :date)
    change_column(:dependent_passports, :date_of_expiry, :date)
    change_column(:dependents, :date_of_birth, :date)

  end

  def self.down
    change_column(:profiles, :date_of_joining, :datetime)
    change_column(:profiles, :date_of_birth, :datetime)

    change_column(:passports, :date_of_issue, :datetime)
    change_column(:passports, :date_of_expiry, :datetime)

    change_column(:dependent_passports, :date_of_issue, :datetime)
    change_column(:dependent_passports, :date_of_expiry, :datetime)
    change_column(:dependents, :date_of_birth, :datetime)
  end
end

class ChangeExperienceLastUsedColumnBackToDate < ActiveRecord::Migration
  def self.up
    change_column(:experiences, :last_used, :date)
  end

  def self.down
    change_column(:experiences, :last_used, :datetime)
  end
end

class Title < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  def self.getAllSortedTitles
    Title.all.collect {|title| title.name.strip}.sort
  end
end

class Degree < ActiveRecord::Base
  validates_presence_of :category, :name
  def self.getAllSortedCategories
     return Degree.all.collect {|degree| degree.category}
  end
 end

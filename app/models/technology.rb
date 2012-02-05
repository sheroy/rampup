class Technology < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name,:allow_nil=>false,:allow_blank=>false
end


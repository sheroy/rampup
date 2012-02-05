class Letterhead < ActiveRecord::Base
  validates_presence_of :office_name, :template_path
  validates_uniqueness_of :office_name
end

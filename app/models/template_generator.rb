class TemplateGenerator < ActiveRecord::Base
  validates_presence_of :name, :file_name

  def file_path
    "#{Rails.root}/doc/templates/#{file_name}"
  end
end

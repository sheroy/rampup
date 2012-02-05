class AttachedDocument < ActiveRecord::Base
  belongs_to :profile

  has_attached_file :document,
                    :url => "/profiles/documents/:employee_id/:document_type/:basename.:extension",
                    :path => ":Rails.root/public/profiles/documents/:employee_id/:document_type/:basename.:extension"

  validates_presence_of :document_type, :message=>'Please select a document type'
  #validates_attachment_size :document, :less_than => 2.megabytes
end

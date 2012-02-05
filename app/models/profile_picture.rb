class ProfilePicture < ActiveRecord::Base
  belongs_to :profile

  has_attached_file :photo,
                    :styles => {:original => "240x320>"},

                    :url => "/profiles/pictures/:id/:basename.:extension",
                    :path => ":Rails.root/public/profiles/pictures/:id/:basename.:extension"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png',  'image/pjpeg',  'image/x-png']

end
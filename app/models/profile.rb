class Profile < ActiveRecord::Base
  attr_accessible :address, :birth_date, :first_name, :gender, :last_name, :mobile, :phone, :zip, :city_id, :photo
  
  belongs_to :user
  belongs_to :city
  
  has_attached_file :photo, 
                    :styles => { 
                      :medium => "300x300>", 
                      :thumb => "100x100>",
                      :icon => "32x32"
                    }, 
                    :default_url => ":style/no-picture-profile.jpg"#,
#                    :storage => :dropbox,
#                    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
#                    :dropbox_options => {
#                      :path => proc { |style| "#{style}/#{id}_#{photo.original_filename}"}
#                    }
  
  
end

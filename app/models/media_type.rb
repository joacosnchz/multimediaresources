class MediaType < ActiveRecord::Base
  has_many :media_media_types
  has_many :material_media_type
  
  attr_accessible :description, :name
end

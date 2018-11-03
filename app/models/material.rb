class Material < ActiveRecord::Base
  belongs_to :user
  belongs_to :media_type
#  has_many :attachments
  
  has_many :material_attachments
  has_many :attachments, :through => :material_attachments
  
  attr_accessible :body, :title, :media_type_id
end

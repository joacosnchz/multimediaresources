class Attachment < ActiveRecord::Base
#  belongs_to :material
  belongs_to :category
  
  has_many :material_attachments
  has_many :materials, :through => :material_attachments
  
  attr_accessible :name, :attach, :category_id
  
  has_attached_file :attach#, 
#    :styles => { 
#      :medium => "300x300>", 
#      :thumb => "100x100>" 
#    }, :default_url => "/attachments/:style/missing.png"#,
#    :content_type => { :content_type => ["image/*", "video/*"] }
    
end

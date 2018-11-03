class MaterialWatcher < ActiveRecord::Base
  belongs_to :user
  belongs_to :material
  belongs_to :created_by, :foreign_key => :created_by_user_id, :class_name => 'User'
  
  attr_accessible :user_id, :material_id, :created_by_user_id
  
  after_create :send_user_notification
  
  def send_user_notification
    material.send_new_material_email(user)
  end
end

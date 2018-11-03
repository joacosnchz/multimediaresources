class MaterialAttachment < ActiveRecord::Base
  belongs_to :material
  belongs_to :attachment
  # attr_accessible :title, :body
end

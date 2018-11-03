class MaterialMediaType < ActiveRecord::Base
  belongs_to :material
  belongs_to :media_type
  # attr_accessible :title, :body
end

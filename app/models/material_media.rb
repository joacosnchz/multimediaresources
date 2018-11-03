class MaterialMedia < ActiveRecord::Base
  belongs_to :media
  belongs_to :material
  # attr_accessible :title, :body
end

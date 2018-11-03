class SentMaterial < ActiveRecord::Base
  belongs_to :user
  belongs_to :material
  # attr_accessible :title, :body
end

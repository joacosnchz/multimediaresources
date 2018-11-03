class MediaMediaType < ActiveRecord::Base
  belongs_to :media
  belongs_to :media_type
  # attr_accessible :title, :body
end

class Media < ActiveRecord::Base
  # has_many :medias
  
  attr_accessible :description, :nombre
end

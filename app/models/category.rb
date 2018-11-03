class Category < ActiveRecord::Base
  attr_accessible :description
  has_many :attachments
end

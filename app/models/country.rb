class Country < ActiveRecord::Base
  attr_accessible :name, :phone_code
  
  has_many :states
end

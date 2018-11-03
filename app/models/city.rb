class City < ActiveRecord::Base
  attr_accessible :name, :phone_area_code
  
  belongs_to :state
  
  def self.datatable_columns
    [
      'id', 'country', 'state', 'name'
    ]
  end
end

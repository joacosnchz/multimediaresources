class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :is_active, :media_id
  # attr_accessible :title, :body
  
  has_one :profile
  # has_many :my_materials, :foreign_key => :user_id, :class_name => 'Material'
  # has_many :material_watchers
  # has_many :materials, through: :material_watchers
  has_many :sent_materials
  belongs_to :media
  
  # http://stackoverflow.com/questions/6004216/devise-forbid-certain-user-from-signing-in
  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using 
    #our own "is_active" column
    super and self.is_active?
  end
  
  after_create :create_profile
  
  def create_profile
    self.profile = Profile.new
  end
  
  def get_i18n_roles
    roles = ''
    self.roles.map(&:name).each do |rol|
      roles << I18n.t("roles.#{rol}")
    end
    roles
  end
  
  def get_role
    self.roles.first.name.to_sym
  end
  
  def send_material_email(material)
    UserMailer.send_material_email(self, material).deliver
  end
  handle_asynchronously :send_material_email, :queue => 'material_emails'
  
  
end

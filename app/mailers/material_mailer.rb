class MaterialMailer < ApplicationMailer
  
  
  def send_new_material_email(material, user)
    @material = material
    @user = user
    @url  = '#'
    
    mail(to: @user.email, subject: 'Nuevo Material disponible')
  end
  
  def send_material_updated_email(material, user)
    @material = material
    @user = user
    @url  = '#'
    
    mail(to: @user.email, subject: 'Material actualizado')
  end
  
  def send_material_deleted_email(material_title, user)
    @material_title = material_title
    @user = user
    
    mail(to: @user.email, subject: 'Material no disponible')
  end
  
  # def send_comment_added_email(material, comment)
  #     
  # end
end

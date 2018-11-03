class UserMailer < ActionMailer::Base
  def send_material_email(user, material)
    @user = user
    @material = material
    @attachments = @material.attachments
    @url = Settings.site.url
    
    mail(to: @user.email, subject: 'Nuevo Material disponible')
  end
end

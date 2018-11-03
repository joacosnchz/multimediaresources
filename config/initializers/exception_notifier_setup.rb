if Rails.env.production?
  Btob::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[#{Settings.site.name} - ERROR] - [#{Rails.env}]",
    :sender_address => %{ "#{Settings.site.name} - [#{Rails.env}] " <exceptions@btob.com.ar> },
    :exception_recipients => %w{paul.eduardo.marclay@gmail.com solucionesit@dsnempresas.com.ar}
end
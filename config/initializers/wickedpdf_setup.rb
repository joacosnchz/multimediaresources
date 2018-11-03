if Rails.env.production?
  path = '/usr/local/bin/wkhtmltopdf'
elsif Rails.env.development?
  path = '/usr/local/bin/wkhtmltopdf'
end

WickedPdf.config = { :exe_path => path }
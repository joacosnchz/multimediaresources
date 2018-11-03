Paperclip.options[:command_path] = "/usr/bin/" if Rails.env.production?
Paperclip.options[:command_path] = "/usr/local/bin/identify" if Rails.env.development?
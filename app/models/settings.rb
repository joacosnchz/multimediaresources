class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml" 
  namespace Rails.env
  
  # Unrolls [ :one, :two ] settings array into [[ "One", :one ], [ "Two", :two ]]
  # picking symbol translations from locale. If setting is not a symbol but
  # string it gets copied without translation.
  #-------------------------------------------------------------------
  def unroll(setting, setting_name)
    setting_name = setting_name.to_s if setting_name.is_a?(Symbol)
    send(setting).map { |key| [ ([Symbol, Fixnum, FalseClass, TrueClass].include?(key.class)) ? I18n.t("#{setting_name}.#{key}") : key, ([Fixnum, FalseClass, TrueClass].include?(key.class)) ? key : key.to_sym ] }
  end
end
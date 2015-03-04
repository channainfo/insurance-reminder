module SettingsHelper
  def tab_active_for(tab)
    active_tab = params[:tab].blank? ? :default : params[:tab].to_sym
    active = ( tab == active_tab ) ? 'active' : ''
    active
  end
end
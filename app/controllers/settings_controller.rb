class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Setting.unscoped
  end

  def update
    [:day_before_expiration_date, :retries, :call_time].each do |key|
      Setting[key] = params[key]
    end

    redirect_to settings_path, notice: 'Setting has been saved'
  end

end

module ApplicationHelper
  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end

  def index_in_paginate(index)
    page = params[:page].to_i >1 ? params[:page].to_i : 1
    index + Kaminari.config.default_per_page * (page - 1 )
  end

  def flash_config
    config = {key: '', value: ''}
    flash.map do |key, value|
      config[:key] = key
      config[:value] = value
    end
    config
  end

  def bootstrap_class_for flash_type
    {notice: 'alert-success', alert: 'alert-danger'}[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end
 
  def app_params
    params.except(:action, :controller, :utf8)
  end

  def in_local_time_zone datetime
    in_time_zone_string(datetime, ENV['LOCAL_TZ'])
  end

  def in_time_zone_string datetime, time_zone = "UTC"
    format = '%Y-%m-%d %H:%M %z'
    zone = datetime.in_time_zone(time_zone)
    zone.strftime(format)
  end

end

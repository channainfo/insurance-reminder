module ApplicationHelper
  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end

  def index_in_paginate(index)
    index + Kaminari.config.default_per_page * params[:page].to_i
  end

  def flash_config
    config = {key: '', value: ''}
    flash.map do |key, value|
      config[:key] = key
      config[:value] = value
    end
    config
  end

  def flash_messages

    trans = { 'alert' => 'alert-danger', 'notice' => 'alert alert-success' }

    content_tag :div, class: 'notification' do
      flash.map do |key, value|
        content_tag 'div', value, class: "alert #{trans[key]} alert-body"
      end.join('.').html_safe
    end
  end

end

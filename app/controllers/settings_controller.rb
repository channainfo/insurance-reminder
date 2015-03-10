class SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Setting.unscoped
    @parameters = verboice_parameters
  end

  def update
    [:day_before_expiration_date, :retries, :call_time, :project, :channel, :call_flow, :schedule].each do |key|
      Setting[key] = params[key]
    end

    redirect_to settings_path(tab: params[:tab]), notice: 'Setting has been saved'
  end

  def verboice
    response = Service::Verboice.auth(params[:email], params[:password])

    if response && response["success"]
      Setting[:verboice_email] = response["email"]
      Setting[:verboice_token] = response["auth_token"]
      render json: {success: true}
    else
      render json: {success: false, message: 'Could not connect to verboice'}, status: :unauthorized
    end
  end

  def schedules
    render json: get_schedules(params[:project])
  end

  def get_schedules(project_id)
    Service::Verboice.connect().schedules(project_id)
  end

  def verboice_parameters
    result = { channels: [], projects: [], call_flows: [], schedules: [] }

    begin
      result[:channels]   = Service::Verboice.connect().channels
      result[:projects]   = Service::Verboice.connect().projects
      result[:call_flows] = Service::Verboice.connect().call_flows
      result[:schedules]  = get_schedules(Setting[:project]) unless Setting[:project].empty?
    rescue JSON::ParserError
      flash.now.alert = " Failed to fetch some data from verboice"
    end

    result
  end
end

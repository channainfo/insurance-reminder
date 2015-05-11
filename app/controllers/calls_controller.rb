class CallsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:notify_call_started, :notify_call_finished]
  skip_before_action :verify_authenticity_token, only: [:notify_call_started, :notify_call_finished]

  before_action :authenticate_spa_service!, only: [:new]

  before_action :fetch_calls, only: [:index, :download_csv]

  def index
    @calls = @calls.page(params[:page])
    @data_by_status = count_by_status @calls
  end

  def create
    options = protected_params.merge(kind: Call::KIND_MANUAL, status: Call::STATUS_ERROR)
    call = Call.new options
    if call.save
      begin
        Service::Verboice.connect.enqueue!(call)
        render json: {status: 1, message: "Reminder has been created"}
      rescue JSON::ParserError
        render json: {status: 0, message: "Could not connect to verboice"}
      end
    else
      render json: {status: 0, message: "Phone number does not exist"}
    end
  end

  def show
    call = Call.search(params).order("created_at DESC").first
    render json: call
  end

  def retry
    main_call = Call.find(params[:id])
    begin
      Service::Verboice.connect.retry_enqueue!(main_call)
      redirect_to calls_path(), notice: "Call has been retried"
    rescue JSON::ParserError
      redirect_to calls_path(), alert: "Could not connect to Verboice"
    end
  end

  def download_csv
    @calls.to_csv

    send_file Call.csv_file, :type => 'text/csv'
  end

  def notify_call_started
    call = Call.find_by_verboice_call_id(params[:CallSid])
    call.mark_as_error! if call

    render text: nil
  end

  def notify_call_finished
    call = Call.find_by_verboice_call_id(params[:CallSid])
    call.mark_as_success! if call

    render text: nil
  end

  def update_status
    ids = params["ids"]
    calls = Call.find ids
    calls.each do |c|
      c.status = Call::STATUS_DISABLED
      c.save!
    end
    render text: "Call with id " + ids.join(",") + " was successfully disabled."
  end

  private

  def protected_params
    params.require(:call).permit(:od_id, :phone_number, :family_code, :full_name, :expiration_date)
  end

  def authenticate_spa_service!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['SHPA_USERNAME'] && password == ['SHPA_USERNAME']
    end
  end

  def count_by_status calls
    data = {}
    calls.each do |c|
      if data[c.status].present?
        data[c.status] = data[c.status] + 1
      else
        data[c.status] = 1
      end
    end
    return data
  end

  def fetch_calls
    @calls = Call.main_calls.includes(:client).order('calls.created_at DESC')
    @calls = @calls.my_ods current_user.get_ods_id
    @calls = @calls.search(params)
  end

end

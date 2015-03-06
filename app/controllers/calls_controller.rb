class CallsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:notify_call_started, :notify_call_finished]
  skip_before_action :verify_authenticity_token, only: [:notify_call_started, :notify_call_finished]

  before_action :authenticate_spa_service!, only: [:new]

  def index
    @calls = Call.main_calls.includes(:client).order('calls.created_at DESC')
    @calls = @calls.search(params).page(params[:page])
  end

  def retry
    call = Call.find(params[:id])

    retry_call = Call.new(
      expiration_date: call.expiration_date,
      phone_number: call.phone_number,
      family_code: call.family_code,
      status: Call::STATUS_ERROR,
      client_id: call.try(:client).try(:id),
      main: call)
    retry_call.save

    begin
      Service::Verboice.connect.retry_call(retry_call)
      redirect_to calls_path(), notice: "Call has been retried"
    rescue
      redirect_to calls_path(), alert: "Could not connect to Verboice"
    end
  end

  def download_csv
    Call.main_calls.includes(:client).order('calls.created_at DESC').search(params).to_csv
    send_file Call.csv_file, :type => 'text/csv'
  end

  def create
    client = Client.find_by_phone_number_on_local_or_remote(params[:phone_number])
    if(client)
      call = Call.new_from(client)
      begin
        Service::Verboice.connect.enqueue(call)
        render json: {status: 1, message: "Reminder has been created"}
      rescue
        render json: {status: 0, message: "Could not connect to verboice"}
      end
    else
      render json: {status: 0, message: "Phone number does not exist"}
    end
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

  private

  def authenticate_spa_service!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['SHPA_USERNAME'] && password == ['SHPA_USERNAME']
    end
  end
end
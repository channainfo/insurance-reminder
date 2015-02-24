class CallsController < ApplicationController
  before_action :authenticate_spa_service!, only: [:new]

  def index
    @calls = Call.main_calls.includes(:client).order('calls.created_at DESC')
    @calls = @calls.search(params).page(params[:page])
  end

  def retry
    call = Call.find(params[:id])
    verboice = Service::Verboice.connect
    verboice.retry_call(call)
    redirect_to calls_path(), notice: "Call have been retried"
  end

  def download_csv
    Call.main_calls.includes(:client).order('calls.created_at DESC').search(params).to_csv
    send_file Call.csv_file, :type => 'text/csv'
  end

  def create
    client = Client.find_by_phone_number_on_local_or_remote(params[:phone_number])
    if(client)
      begin
        verboice = Service::Verboice.connect.call(client)
        render json: {status: 1, message: "Reminder has been created"}
      rescue
        render json: {status: 0, message: "Could not connect to verboice"}
      end
    else
      render json: {status: 0, message: "Phone number does not exist"}
    end
  end

  private

  def authenticate_spa_service!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['SHPA_USERNAME'] && password == ['SHPA_USERNAME']
    end
  end
end
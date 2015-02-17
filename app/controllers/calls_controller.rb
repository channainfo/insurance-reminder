class CallsController < ApplicationController
  def index
    @calls = Call.main_calls.includes(:client).order('calls.created_at DESC')
    @calls = @calls.search(params).page(params[:page])
  end

  def retry
    call = Call.find(params[:id])
    verboice = Verboice.connect
    verboice.retry_call(call)
    redirect_to calls_path(), notice: "Call have been retried"
  end

  def download_csv
    Call.main_calls.includes(:client).order('calls.created_at DESC').search(params).to_csv
    send_file Call.csv_file, :type => 'text/csv'
  end
end
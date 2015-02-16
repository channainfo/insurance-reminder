class CallsController < ApplicationController
  def index
    @calls = Call.main_calls.includes(:client).order('calls.created_at DESC')
    @calls = @calls.search(params).page(params[:page])
  end

  def retry
    call = Call.find(params[:id])
    if call.retry
      redirect_to calls_path(), notice: "Call have been retried"
    else
      redirect_to calls_path(), alert: "Failed to retry to call this number, please try again"
    end
  end
end
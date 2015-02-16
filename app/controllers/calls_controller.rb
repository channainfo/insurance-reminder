class CallsController < ApplicationController
  def index
    @calls = Call.main_calls.includes(:client).order('created_at DESC').page(params[:page])
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
class CallsController < ApplicationController
  def index
    @calls = Call.includes(:client).order('created_at DESC').page(params[:page])
  end
end
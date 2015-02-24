class CallLogsController < ApplicationController
  before_action :set_verboice_connection
  def index
    phone_numbers = @verboice.call_logs
    render json: phone_numbers.map
  end

  private

  def set_verboice_connection
    @verboice = Service::Verboice.connect
  end
end
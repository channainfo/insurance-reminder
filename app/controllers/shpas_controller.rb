class ShpasController < ApplicationController
  def index
    client = Client.find_by_phone_number_on_local_or_remote(params[:phone_number])
    p "client: "
    p client
    render text: client
  end
end
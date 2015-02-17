class StepsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def manifest
    render file: File.join(Rails.root, 'config', 'step_manifest.xml')
  end

  def notify_call_failed
    call = Call.find_by_verboice_call_id(params[:CallSid])
    call.mark_as_error! if call

    render text: nil
  end

  def notify_call_success
    call = Call.find_by_verboice_call_id(params[:CallSid])
    call.mark_as_success! if call

    render text: nil
  end
end

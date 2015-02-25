class StepsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def manifest
    render file: File.join(Rails.root, 'config', 'step_manifest.xml')
  end

end

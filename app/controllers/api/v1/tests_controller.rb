class Api::V1::TestsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  # Just skip the authentication for now
  # before_filter :authenticate_user!

  respond_to :json

  def index
    render :text => '{
      "success":true,
      "info":"ok",
      "data":{
              "Testing Rave Server w/json": "OK"
             }
    }'
  end
end
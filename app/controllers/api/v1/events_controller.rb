class Api::V1::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    # TO DO 
    binding.pry
    event = User.find(params[:event][:user_id]).events.new(params[:event])
    # Later on might have to change to current_user
    if event.save
      
      render :status => 200,
           :json => { :success => true,
                      :info => "Event created",
                      :data => { :event => event } 
                    }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => event.errors,
                        :data => {} }
    end
  end
end
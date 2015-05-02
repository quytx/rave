class Api::V1::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def index
    @events = Event.all
    respond_with(@events)
  end

  def show
    @event = Event.find(params[:event_id])
    if @event
      respond_with(@event)
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @event.errors,
                        :data => {} }
    end
  end

  def show_photos
    @event = Event.find(params[:event_id])
    if @event
      @photos = @event.photos.all
      respond_with(@photos)
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @event.errors,
                        :data => {} }
    end
  end

  def create
    # TO DO 
    event = User.find(params[:event][:user_id]).events.new(params[:event])
    # Later on might have to change to current_user (use session)
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
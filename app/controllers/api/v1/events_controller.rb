class Api::V1::EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def index
    curr_time = Time.now.in_time_zone("Central Time (US & Canada)")
    @events = Event.where("end_time > ?", curr_time).sort_by(&:end_time)
    respond_with(@events)
  end

  def myevents
    @user = User.find(user_id: params[:user_id])
    if @user
      @events = @user.attended_events
      respond_with(@events)
    else
      ender :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => "No user",
                        :data => {} }
    end
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

  def checkin
    begin
      @ev = EventParticipant.where(user_id: params[:user_id], event_id: params[:event_id]).first!
    rescue
      ev = EventParticipant.new(user_id: params[:user_id], event_id: params[:event_id])
      if ev.save
        render :status => 200,
           :json => { :success => true,
                      :info => "Checked in successfully!",
                      :checked_in => true
                    }
        return            
      else
        render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => ev.errors,
                        :data => {} }           
      end                  
    end
    if @ev
      EventParticipant.destroy(@ev)
      render :status => 200,
           :json => { :success => true,
                      :info => "You're now checked out.",
                      :checked_in => false
                    }
    end
  end

  def status
    begin
      @ev = EventParticipant.where(user_id: params[:user_id], event_id: params[:event_id]).first!
    rescue
      render :status => 200,
         :json => { :success => true,
                    :checked_in => false
                  }    
      return                       
    end
    if @ev
      render :status => 200,
             :json => { :success => true,
                        :checked_in => true
                      }
    end                
  end

  def create
    # TO DO 
    @event = User.find(params[:event][:user_id]).events.new()
    # Later on might have to change to current_user (use session)
    @event.name = params[:event][:name]
    @event.description = params[:event][:description]
    @event.location = params[:event][:location]
    date_and_time = '%m-%d-%Y %H:%M:%S %Z'
    begin
      @event.start_time = DateTime.strptime(params[:event][:start_time]+ " Eastern Time (US & Canada)", date_and_time)
    rescue
      @event.start_time = nil
    end
    begin
      @event.end_time = DateTime.strptime(params[:event][:end_time]+ " Eastern Time (US & Canada)", date_and_time)
    rescue
      @event.end_time = nil
    end

    if @event.save

      # if photo included
      if params[:photo]
        @photo = @event.photos.create(user_id: @event.user_id)
        img_local_path = saveImg(params[:photo][:imgBase64])
        File.open(img_local_path) do |file|
          @photo.url = file
          @photo.save!
        end
        File.delete(img_local_path)
        # Set default cover photo
        if !@event.cover_photo
          @event.cover_photo = @photo.url.url
          @event.save!
        end
      end 

      ev = EventParticipant.new(user_id: params[:event][:user_id], event_id: @event.id)
      ev.save!
        
      render :status => 200,
           :json => { :success => true,
                      :info => "Event created",
                      :data => { :event => @event } 
                    }
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @event.errors,
                        :data => {} }
    end
  end
end
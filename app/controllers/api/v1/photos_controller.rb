include PhotosHelper
class Api::V1::PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    # Convert Base64 to IMG
    img_local_path = saveImg(params[:imgBase64])

    # Save photo
    begin
      userID = params[:user_id] || current_user.id
    rescue Exception
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => "Must be logged in or specify user_id to upload",
                        :data => {} }
      return                  
    end

    @event = Event.find(params[:event_id])
    @photo = nil
    if @event
      @photo = @event.photos.create!(user_id: userID)
      File.open(img_local_path) do |file|
        @photo.url = file
        @photo.save!
      end
    end
    # Set default cover photo
    if !@event.cover_photo
      @event.cover_photo = @photo.url.url
      @event.save!
    end
    File.delete(img_local_path)
    if @photo
      respond_with(@photo)
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @photo.errors,
                        :data => {} }
    end
  end

  def show
    @photo = Photo.find(params[:photo_id])
    if @photo
      respond_with(@photo)
    else
      render :status => :unprocessable_entity,
             :json => { :success => false,
                        :info => @photo.errors,
                        :data => {} }
    end
  end

end
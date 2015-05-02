class Api::V1::PhotosController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  def create
    # TO DO 

    
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
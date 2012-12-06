class PhotosController < ApplicationController

  require 'open-uri'

  respond_to :json

  def index
    if params[:newImage]
      respond_to do |format|
        format.html { render partial: 'photos/landing'}
      end
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def create
    @photo = Photo.create(params[:photo])

    respond_to do |format|
      format.json { render partial: 'photos/single_filter', locals: { photo: @photo } }
    end
  end

end

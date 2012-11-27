class PhotosController < ApplicationController
  def index
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def create
    @photo = Photo.create(params[:photo])
    respond_to do |format|
      format.json { render partial: 'photos/filter', locals: { photo: @photo } }
    end
  end

end

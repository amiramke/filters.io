require 'spec_helper'

describe Photo do

  let (:photo) { FactoryGirl.build(:photo) }

  it "has a url" do
    photo.url.should_not be_nil
  end

  it "validates presence of url" do
    invalid_photo = Photo.new
    invalid_photo.should_not be_valid
  end

end
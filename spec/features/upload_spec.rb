require 'spec_helper'

describe 'Uploading', js: true do

  before (:each) { visit root_path }
  
  it "shows an upload button" do
    page.should have_button("upload")
  end

  it "opens filepicker modal when upload link is clicked" do
    click_button("upload")
    page.has_selector?("div#filepicker_dialog_container").should be_true
  end

end
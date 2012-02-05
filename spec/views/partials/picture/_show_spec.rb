require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "Show Photo" do
  it "should display default image if there is no photo" do
    profile = Profile.new(:picture=>nil)
    assigns[:profile] = profile
    render :partial=>'partials/picture/show', :locals=>{:profile => profile}
    response.should have_tag("img[alt='Default_image']")
  end

  it "should display photo if there is a photo" do
    profile = Profile.new
    profile.profile_picture = ProfilePicture.new

    profile.profile_picture.photo.should_receive(:url).and_return("paperclip.jpg")

    assigns[:profile] = profile

    render :partial => 'partials/picture/show', :locals => {:profile => profile}

    response.should have_tag("img[alt='Paperclip']")
  end

end
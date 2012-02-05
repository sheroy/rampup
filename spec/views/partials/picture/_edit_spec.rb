require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe "Edit Photo" do
  it "should display upload photo if there is no photo" do
    profile = Profile.new(:picture=>nil)
    assigns[:profile] = profile
    render :partial=>'partials/picture/edit', :locals=>{:profile => profile}
    response.should have_tag("a[href='/partials/picture/get']", "Upload Photo")
  end

  it "should display change photo if there is a photo" do
    profile = Profile.new
    profile.profile_picture = ProfilePicture.new

    profile.profile_picture.photo.should_receive(:url).and_return("image.jpg")

    assigns[:profile] = profile

    render :partial => 'partials/picture/edit', :locals => {:profile => profile}

    response.should have_tag("a[href='/partials/picture/get']", "Change Photo")
  end

end
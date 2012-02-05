require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Super Admin Menu" do
  it "should display the navigation bar" do
    render :partial=>'partials/nav_bar/super_admin_menu'
    response.should be
    response.should have_tag('div.left-area') do
      with_tag('h3','Navigation')
      with_tag('ul') do
        with_tag('li') do
          with_tag('a[href=/visa_categories]', "Visa Categories")
        end
      end
    end
  end
end
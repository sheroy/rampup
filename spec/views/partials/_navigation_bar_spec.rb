require File.dirname(__FILE__) + '/../../spec_helper'

describe "Navigation bar" do

  describe "when logged in as admin" do

    before(:each) do
      @controller.set_current_user(User.new(:role=>"admin"))

    end

    describe "and does not pass the incomplete profile parameter" do

      it "should display admin navigation bar links" do
        render :partial=>'partials/layout/navigation_bar'
        response.should be_success

        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/admin]', "Homepage")
            with_tag('a[href=/profiles/incomplete]', "Incomplete Master Data")
          end
        end
      end
    end

    describe "and passes the incomplete profile parameter" do
      it "should display complete profile link" do
        render :partial=>'partials/layout/navigation_bar', :incomplete=>false
        response.should be_success
        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/admin]', "Homepage")
            with_tag('a[href=/profiles/incomplete]', "Incomplete Master Data")
          end
        end
      end

    end

  end


  describe "when logged in as employee" do

    before(:each) do
      @controller.set_current_user(User.new(:role=>"employee"))
    end

      it "should display employee navigation bar links" do
        render :partial=>'partials/layout/navigation_bar'
        response.should be_success

        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/employee]', "My Details")
          end
        end
      end

      it "should display employee sub menu tabs" do
        render :partial=>'partials/employee/submenu'
        response.should be_success

        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/employee]', "Personal Details")
          end
        end
      end

      it "should have Passport Details" do
        render :partial=>'partials/employee/submenu'
        response.should be_success

        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/employee/passport]', "Passport Details")
          end
        end
      end

      it "should have Financial Details" do
        render :partial=>'partials/employee/submenu'
        response.should

        response.should have_tag('ul') do
          with_tag('li') do
            with_tag('a[href=/employee/financial]', "Financial Details")
          end
        end
      end
  end
end

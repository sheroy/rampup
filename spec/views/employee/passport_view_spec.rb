require "spec_helper"

describe EmployeeController do

  before(:each) do
    @profile = ModelFactory.create_profile
    @passport = ModelFactory.create_passport(:profile => @profile)
    dependent_passport=ModelFactory.create_dependent_passport(:profile => @profile)
    @dependent_passports=[dependent_passport]
    assigns[:passport] = @passport
    assigns[:profile] = @profile
    assigns[:dependent_passports]=@dependent_passports
  end

  it "should render passport details" do
    template.should_receive(:render).with(:partial => 'partials/passport/passport_information', :locals => {
        :passport => @passport,
        :profile => @profile
    })
    render :template=>'employee/passport'
  end

  it "should have an edit button" do
    render :template=>'employee/passport'
    response.should have_tag("a[href='#{edit_passport_path}']", "Edit")
  end

  it "should render passport edit fields" do
    template.should_receive(:render).with(:partial => 'partials/passport/passport_form', :locals => {
        :passport => @passport, :profile => @profile
    })
    render :template=>'passport/edit'
  end

  it "should render dependent passport fields" do
    template.should_receive(:render).with(:partial=>'partials/passport/dependent_passport_list',
                                          :locals=>{:profile=>@profile, :dependent_passports=>@dependent_passports, :immigration_view=>true, :admin => false}
    )
    render :template=>'employee/passport'
  end

end

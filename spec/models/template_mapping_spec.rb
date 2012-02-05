require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe TemplateMapping do
  before(:each) do
    @profile=ModelFactory.create_profile
    @qualification=ModelFactory.create_qualification(:profile_id=>@profile.id)
    @medical=ModelFactory.create_medical_dependent(:profile_id=>@profile.id)
    @life=ModelFactory.create_life_insurance_beneficiary(:profile_id=>@profile.id)
  end

  it "should get all the profile data" do
    profile_info=TemplateMapping.get_profile_data(@profile.id)
  end
end
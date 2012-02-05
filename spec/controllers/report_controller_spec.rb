require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ReportController do
  before(:each) do
    @profile=ModelFactory.create_profile(:employee_id=>'16787')
  end

  it "should generate the excel sheet for checklist report" do
    Exporter::ReportGenerator.should_receive(:create_checklist_report).with("#{Rails.root}/reports/checklist_report.xls")
    @controller.should_receive(:send_file).with("#{Rails.root}/reports/checklist_report.xls",:disposition => 'attachment', :encoding => 'utf8' ,
      :type => 'application/octet-stream')
    get :checklist_report_exporter
    response.should be_success
  end
  it "should generate the excel sheet for medical insurance additions" do
    Profile.should_receive(:get_profile_within_the_date_range).and_return([@profile])
    @controller.should_receive(:convert_to_date).twice
    Exporter::ReportGenerator.should_receive(:medical_insurance_export).with("#{Rails.root}/reports/medical_insurance_additions.xls","Date Of Joining","date_of_joining",[@profile])
    @controller.should_receive(:send_file).with("#{Rails.root}/reports/medical_insurance_additions.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
    get :generate,:commit=>"Generate Medical Insurance-Additions"
  end
  it "should generate the excel sheet for medical insurance removals" do
    Profile.should_receive(:get_exit_employees_within_given_date_range).and_return([@profile])
    @controller.should_receive(:convert_to_date).twice
    Exporter::ReportGenerator.should_receive(:medical_insurance_export).with("#{Rails.root}/reports/medical_insurance_deletions.xls","Date Of Exit","last_day",[@profile])
    @controller.should_receive(:send_file).with("#{Rails.root}/reports/medical_insurance_deletions.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
    get :generate,:commit=>"Generate Medical Insurance-Deletions"
  end
  it "should generate the excel sheet for life insurance additions" do
    Profile.should_receive(:get_profile_within_the_date_range).and_return([@profile])
    @controller.should_receive(:convert_to_date).twice
    Exporter::ReportGenerator.should_receive(:life_insurance_export).with("#{Rails.root}/reports/life_insurance_additions.xls","Date Of Joining","date_of_joining",[@profile])
    @controller.should_receive(:send_file).with("#{Rails.root}/reports/life_insurance_additions.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
    get :generate,:commit=>"Generate Life Insurance-Additions"
  end
  it "should generate the excel sheet for life insurance deletions" do
    Profile.should_receive(:get_exit_employees_within_given_date_range).and_return([@profile])
    @controller.should_receive(:convert_to_date).twice
    Exporter::ReportGenerator.should_receive(:life_insurance_export).with("#{Rails.root}/reports/life_insurance_deletions.xls","Date Of Exit","last_day",[@profile])
    @controller.should_receive(:send_file).with("#{Rails.root}/reports/life_insurance_deletions.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
    get :generate,:commit=>"Generate Life Insurance-Deletions"
  end
  it "should convert the hash into date" do
    date_value=@controller.convert_to_date({"start(1i)"=>4,"start(2i)"=>5,"start(3i)"=>2009},"start")
    date_value.should==Date.parse("05/04/2009").to_date
  end
  
  describe "export" do
    it "should export excel sheet to user" do
      get :generate
      response.should be_success
    end
  end
  
  describe "no passport exporter" do
   it "should generate excel sheet with profiles who do not have passport" do
      @profile=ModelFactory.create_profile(:employee_id=>'16788')
      Profile.should_receive(:get_employees_with_no_passport).and_return([@profile])
      Exporter::ReportGenerator.should_receive(:no_passport_export).with("#{Rails.root}/reports/no_passport_profiles.xls",[@profile])
      @controller.should_receive(:send_file).with("#{Rails.root}/reports/no_passport_profiles.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
      get :no_passport_exporter
   end
  end

  describe "customized report exporter" do
    it "should generate excel sheet according the fields chose by admin" do
      @profile = ModelFactory.create_profile(:employee_id=>'16788')
      Profile.should_receive(:get_customized_report).and_return([@profile])
      customized_report_path = "#{Rails.root}/reports/custom_report_#{Time.now.strftime("%b_%d_%Y")}.xls"
      Exporter::ReportGenerator.should_receive(:custom_report_export).with(customized_report_path,[@profile])
      @controller.should_receive(:send_file).with(customized_report_path, :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
      get :custom_report_exporter
      response.headers['Content-Length'].to_i.should > 0
    end
  end
  describe "birthday babies exporter" do
  it "should generate excel sheet of birthday babies for a month and location" do
     @profile=ModelFactory.create_profile(:date_of_birth=>DateTime.now.to_date)
     country = Country.find_by_name('India')
     locations=Location.find_all_by_countries_id(country.id)
     locations.each do |location|
        Profile.should_receive(:get_birthday_babies).with(DateTime.now.month.to_s, location.id).and_return([@profile])
     end

     Exporter::ReportGenerator.should_receive(:birthday_babies_export).with("#{Rails.root}/reports/birthday_babies.xls",locations.size.times.map{|i| [@profile]})
     @controller.should_receive(:send_file).with("#{Rails.root}/reports/birthday_babies.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
     get :birthday_babies_exporter,:date=>{:month => DateTime.now.month.to_s}
  end
  end
  describe "profiles with expiring passports" do
   it "should generate excel sheet with profiles whose passports are expiring in the next 8 months" do
     @profile=ModelFactory.create_profile(:employee_id=>'16789')
     Profile.should_receive(:expiring_passports).and_return([@profile])
     Exporter::ReportGenerator.should_receive(:passport_expiry_profiles_export).with("#{Rails.root}/reports/profiles.xls",[@profile])
     @controller.should_receive(:send_file).with("#{Rails.root}/reports/profiles.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
     get :passport_expiring_profiles_exporter
   end
   it "should generate excel sheet with profiles whose passports have expired" do
     @profile=ModelFactory.create_profile(:employee_id=>'16790')
     Profile.should_receive(:get_employees_whose_passports_have_expired).and_return([@profile])  
     Exporter::ReportGenerator.should_receive(:passport_expiry_profiles_export).with("#{Rails.root}/reports/expired_passports_profiles.xls",[@profile])
     @controller.should_receive(:send_file).with("#{Rails.root}/reports/expired_passports_profiles.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
     get :passport_expired_profiles_exporter
   end
  end
  describe "exporter" do
    it "should render the excel file" do
      Exporter::ExcelExporter.should_receive(:export).with("#{Rails.root}/reports/report.xls","Incomplete")
      @controller.should_receive(:send_file).with("#{Rails.root}/reports/report.xls", :disposition => 'attachment',:encoding => 'utf8', :type => 'application/octet-stream')
      get :profiles_exporter, :option=>'Incomplete'
      response.should be_success
    end
  end
end
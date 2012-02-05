
namespace :db do
  task :import_templates => :environment do
    Rake::Task["db:copy_files"].invoke
    Rake::Task["db:populate_database"].invoke
  end

  task :copy_files do
    cp_r("doc/templates", "public/system/")
  end

  task :populate_database do
    TemplateGenerator.find_or_create_by_name('Confidentiality Agreement - Deepa', :file_name => 'Confidentiality Agreement - Deepa.xml', :document_type => 1, :selected => 0, :created_at => '2009-09-08 17:50:48', :updated_at => '2009-10-05 21:23:41')
    TemplateGenerator.find_or_create_by_name('Confidentiality Agreement - Sitaraman', :file_name => 'Confidentiality Agreement - Sitaraman.xml', :document_type => 1, :selected => 0, :created_at => '2009-09-08 17:51:08', :updated_at => '2009-09-22 13:23:38')
    TemplateGenerator.find_or_create_by_name('Page 1 - Employee Data Sheet', :file_name =>'Page 1 - Employee Data Sheet.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:51:27', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 5 - Life Insurance - Enrollment', :file_name =>'Page 5 - Life Insurance - Enrollment.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:52:47', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 6 - Gratuity Nomination', :file_name =>'Page 6 - Gratuity Nomination.xml', :document_type => 1, :selected => 1, :created_at =>'2009-09-08 17:53:08', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 7 - Cellular Phone Waiver', :file_name =>'Page 7 - Cellular Phone Waiver.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:53:27', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 8 - Vacation pay before it is earned-India', :file_name =>'Page 8 - Vacation pay before it is earned-India.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:53:45', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 9 - Waiver of Negligence & Release', :file_name => 'Page 9 - Waiver of Negligence & Release.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:54:05', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 10 & 11 - PF Nominataion and Declaration', :file_name =>'Page 10 & 11 - PF Nominataion and Declaration.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:54:22', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Page 12 - Sexual Harassment Policy', :file_name => 'Page 12 - Sexual Harassment Policy.xml', :document_type => 1, :selected => 1, :created_at => '2009-09-08 17:54:38', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Address Proof', :file_name =>'Address Proof.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:55:04', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Bank Account Letter', :file_name => 'Bank Account Letter.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:55:23', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('China Biz Visa', :file_name => 'China Biz Visa.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:55:35', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Forex Purchase - Centurion Bank', :file_name =>'Forex Purchase - Centurion Bank.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:55:50', :updated_at =>'2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Forex Purchase - VKC', :file_name => 'Forex Purchase - VKC.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:56:13', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Forex Purchase - Weizmann', :file_name =>'Forex Purchase - Weizmann.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:56:29', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('H1B Cover Letter', :file_name => 'H1B Cover Letter.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:56:43', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Laptop Letter.xml', :file_name =>'Laptop Letter.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:57:06', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('Oz Biz Visa', :file_name =>'Oz Biz Visa.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:57:20', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('UK Biz Visa', :file_name =>'UK Biz Visa.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:57:34', :updated_at => '2009-09-08 17:58:23')
    TemplateGenerator.find_or_create_by_name('UK Work Permit', :file_name =>'UK Work Permit.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:57:49', :updated_at => '2009-09-08 19:33:27')
    TemplateGenerator.find_or_create_by_name('US Biz Visa', :file_name =>'US Biz Visa.xml', :document_type => 0, :selected => 1, :created_at => '2009-09-08 17:58:02', :updated_at => '2009-09-08 19:33:27')
    TemplateGenerator.find_or_create_by_name('Patricia Carlin', :file_name =>'CONFIDENTIALITY AGREEMENT - Patricia Carlin.xml', :document_type => 1, :selected => 0, :created_at => '2009-10-27 19:13:23', :updated_at => '2010-08-11 11:09:22')
    TemplateGenerator.find_or_create_by_name('Leave Auth Letter', :file_name =>'LeaveAuthorization.xml', :document_type => 0, :selected => 1, :created_at => '2009-11-03 18:31:26', :updated_at => '2009-11-03 18:31:45')
    TemplateGenerator.find_or_create_by_name('Page 2 & 3 - Dependent Undertaking', :file_name => 'Page 2 & 3 - Dependent Undertaking.xml', :document_type => 1, :selected => 1, :created_at => '2009-11-18 12:45:47', :updated_at => '2009-11-18 12:46:28')
    TemplateGenerator.find_or_create_by_name('Confidentiality Agreement Anand Iyengar ', :file_name => 'CONFIDENTIALITY AGREEMENT - Anand Iyengar.xml', :document_type => 1, :selected => 1, :created_at => '2010-08-11 11:14:35', :updated_at => '2010-08-11 11:15:41')
    TemplateGenerator.find_or_create_by_name('Page 4 - Medical Insurance - Enrollment', :file_name =>'Page 4 - Medical Insurance - Enrollment.xml', :document_type => 1, :selected => 1, :created_at => '2010-12-23 13:48:40', :updated_at =>'2010-12-27 13:09:56')
  end
end
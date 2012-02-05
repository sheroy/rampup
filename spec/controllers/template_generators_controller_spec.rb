require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TemplateGeneratorsController do

  def mock_template_generator(stubs={})
    @mock_template_generator ||= mock_model(TemplateGenerator, stubs)
  end

  before(:each) do
   @controller.instance_eval {flash.stub!(:sweep) }
  end
  
  describe "responding to GET index" do

    it "should expose all template_generators as @template_generators" do
      TemplateGenerator.create!(:name=>'file1',:file_name=>'filename1',:document_type=>false)
      TemplateGenerator.create!(:name=>'file2',:file_name=>'filename1',:document_type=>false)
      TemplateGenerator.create!(:name=>'file3',:file_name=>'filename1',:document_type=>true)
      get :index
      
      assigns(:mandatory_template_generators).size.should == 1
      assigns(:optional_template_generators).size.should == 2
      
      
    end

  end

  describe "responding to GET show" do

    it "should expose the requested template_generator as @template_generator" do
      TemplateGenerator.should_receive(:find).with("37").and_return(mock_template_generator)
      get :show, :id => "37"
      assigns[:template_generator].should equal(mock_template_generator)
    end
    
    describe "with mime type of xml" do

      it "should render the requested template_generator as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        TemplateGenerator.should_receive(:find).with("37").and_return(mock_template_generator)
        mock_template_generator.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new template_generator as @template_generator" do
      TemplateGenerator.should_receive(:new).and_return(mock_template_generator)
      get :new
      assigns[:template_generator].should equal(mock_template_generator)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested template_generator as @template_generator" do
      TemplateGenerator.should_receive(:find).with("37").and_return(mock_template_generator)
      get :edit, :id => "37"
      assigns[:template_generator].should equal(mock_template_generator)
    end
  end

  describe "responding to POST create" do

    describe "with valid params" do
      integrate_views
      it "should upload_spreadsheet the file" do
        @template_generator = TemplateGenerator.new
        uploaded_file = mock("uploaded file", :original_path=>"#{Rails.root}/tmp/tmp_file", :original_filename => "tmp_file")
        TemplateGenerator.should_receive(:new).and_return(@template_generator)
        DataFile.should_receive(:save).with("datafile"=>uploaded_file).and_return(true)
        @template_generator.should_receive(:save).and_return(true)
        post :create, :template_generator => {:name => "", :selected => "true",  :document_type => "true"}, :upload_spreadsheet=>{:datafile=>uploaded_file}
        response.should redirect_to(template_generators_path)
        flash[:notice].should == "Template saved"        
      end
      
      it "should render new if record could not be saved" do
        uploaded_file = mock("uploaded file", :original_path=>"#{Rails.root}/tmp/tmp_file", :original_filename => "tmp_file")
        @controller.should_receive(:render).with(:action => "new")
        post :create, :template_generator => {:name => "", :selected => "true",  :document_type => "true"}, :upload_spreadsheet=>{:datafile=>uploaded_file}
        flash[:error].should == "All fields marked * are mandatory. "        
      end
    end    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested template_generator" do
        valid_args = {:name => "name", :file_name => "file_name", :document_type => "true"}
        template1 = TemplateGenerator.create!(valid_args)
        uploaded_file = mock("uploaded file", :original_path=>"#{Rails.root}/tmp/tmp_file", :original_filename => "tmp_file",:file_name=>"tmp_file")
        put :update, :id => template1.id , :template_generator => valid_args, :upload_spreadsheet=>{:datafile=>uploaded_file}
        flash[:notice].should == "Template saved"
        response.should redirect_to(template_generators_path)
      end

      it "should give an error when it is not able to save a file" do
        valid_args = {:name => "name", :file_name => "file_name", :document_type => "true"}
        @template_generator = mock("mock template", :name=>'name', :file_name=>'file_name', :document_type=>'true')
        template1 = TemplateGenerator.create!(valid_args)
        TemplateGenerator.should_receive(:find).and_return(@template_generator)
        @template_generator.should_receive(:update_attributes)
        @template_generator.should_receive(:save).and_return(false)
        uploaded_file = mock("uploaded file", :original_path=>"#{Rails.root}/tmp/tmp_file", :original_filename => "tmp_file",:file_name=>"tmp_file")
        put :update, :id => template1.id , :template_generator => valid_args, :upload_spreadsheet=>{:datafile=>uploaded_file}
        flash[:error].should == "Cannot save file"   
        response.should render_template('edit')     
      end
    end
    
    describe "responding to bulk update" do
      before(:each) do
        @template_generator1 = TemplateGenerator.create!(:name=>'location1',:selected=>false, :file_name=>'1')
        @template_generator2 = TemplateGenerator.create!(:name=>'location2',:selected=>false, :file_name=>'2')
        @template_generator3 = TemplateGenerator.create!(:name=>'location3',:selected=>false, :file_name=>'3')        
      end
      it "should change the selected boolean for selected templates" do
        put :update, :selected=>[@template_generator1.id.to_s,@template_generator2.id.to_s,@template_generator3.id.to_s]
        @template_generator1 = TemplateGenerator.find(@template_generator1.id)
        @template_generator2 = TemplateGenerator.find(@template_generator2.id)
        @template_generator3 = TemplateGenerator.find(@template_generator3.id)
        @template_generator1.selected.should be
        @template_generator2.selected.should be
        @template_generator3.selected.should be
        flash[:notice].should == "Successsfully updated"
        response.should redirect_to(template_generators_path)
      end
    end
  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested template_generator" do
      TemplateGenerator.should_receive(:find).with("37").and_return(mock_template_generator)
      File.should_receive(:exists?).and_return(true)
      mock_template_generator.should_receive(:file_name).twice.and_return('file_name')
      File.should_receive(:delete)
      mock_template_generator.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the template_generators list" do
      TemplateGenerator.stub!(:find).and_return(mock_template_generator(:destroy => true))
      mock_template_generator.should_receive(:file_name).twice.and_return('file_name')
      File.should_receive(:exists?).and_return(true)
      File.should_receive(:delete)
      delete :destroy, :id => "1"
      response.should redirect_to(template_generators_url)
    end
  end
end
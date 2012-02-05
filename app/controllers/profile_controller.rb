require 'spreadsheet'
class ProfileController < ApplicationController
   load_and_authorize_resource

  before_filter :set_selected_tab

  def show
    @profile = Profile.find(params[:id])
  end

  def rm_show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
    @titles = Title.all
    render :template => 'profile/profile_form'
  end

  def edit
    @profile = Profile.find(params[:id])
    @titles = Title.all
    render :template => 'profile/edit_profile_form'
  end

  def edit_last_day
    @profile = Profile.find(params[:id])
  end

  def save_last_day
    @profile = Profile.find_by_id(params[:id])
    @profile.attributes = params[:profile]
    if (!@profile.valid?) && (@profile.errors[:last_day].present?)
      flash[:error] = "Error in date of exit"
    else
      @profile.save(:validation => false)
      flash[:notice]="Last date has been saved successfully"
    end
    redirect_to show_profile_path(params[:id])
  end

  def rejoins
    begin
      @profile = Profile.find_by_id(params[:id])
      unless @profile.last_day.blank?
        @profile.last_day = nil
        @profile.completed = false
        @profile.save(:validate => false)
        flash[:notice] = "Employee is Updated to a rejoined employee"
      else
        flash[:error] = "Employee is already an existing employee."
      end
      redirect_to show_profile_path(@profile)
    rescue
      flash[:notice] = "Profile Not Found"
      redirect_to admin_home_path
    end
  end

  def complete
    @profile = Profile.find_by_id(params[:id])
    if @profile.save
      @profile.mark_as_complete
      flash[:notice] = "Profile was successfully saved."
      redirect_to show_profile_path(@profile.id)
    else
      @errors = "Following errors prohibited the profile from being saved <br />"
      @profile.errors.each do |key,value|
        if(key.to_s.eql?("title"))
          @errors = @errors + "Role - #{value}" + "<br />"
        else
          @errors = @errors + "#{key} - #{value}" + "<br />"
        end
      end
      flash[:error] = @errors.html_safe
      redirect_to edit_profile_path(@profile.id)
    end
  end

  def save_as_draft
    @profile.valid?
    if (@profile.errors.on(:employee_id).nil?)
      @profile.completed = false
      @profile.save(:validate => false)
      flash.now[:notice] = "Profile Temporarily Saved"
    else
      flash.now[:error] = "Employee ID should be a unique 5 digit number"
    end
    params[:action] == "create" ? (render :template=>'profile/profile_form') : (render :template => 'profile/edit_profile_form')
  end

  def update
    attributes = params[:profile].merge(:id => params[:id], :years_of_experience => ((params[:years].to_i * 12)+params[:months].to_i).to_s)
    @titles = Title.all
    @profile=Profile.find_by_id(params[:id])
    @profile[:type]=attributes[:type]
    @profile.attributes=attributes
    if (params[:commit] != "Save As Draft")
      save_without_validation
    else
      save_as_draft
    end
  end

  def create
    attributes = params[:profile].merge(:id => params[:id], :years_of_experience => ((params[:years].to_i * 12)+params[:months].to_i).to_s)
    @titles = Title.all
    @profile = (Profile.exists?(params[:id])) ? Profile.find(params[:id]) : Profile.new
    @profile[:type]=attributes[:type]
    @profile.attributes=attributes
    if (params[:commit] != "Save As Draft")
      save_without_validation
    else
      save_as_draft
    end
  end

  def financial_details
    @profile = Profile.find(params[:id])
  end

  def passport_information
    @profile = Profile.find(params[:id])
    if @profile.passport.nil?
      @passport = Passport.find_or_initialize_by_profile_id(params[:id])
    else
      @profile.passport = Passport.new
      @passport = @profile.passport
    end
  end

  def save_financial_details
    @profile=Profile.find(params[:id])
    @profile.attributes = params[:profile]
    if @profile.save(:validate => false)
      if (params[:commit] == "Save As Draft")
        flash.now[:notice] = "Profile Temporarily Saved"
        render :action=>"financial_details",:id => @profile
      else
        flash[:notice] = "Verify all the details and #{ActionController::Base.helpers.link_to('Click here', complete_profile_path(@profile))} to save as final".html_safe 
        redirect_to show_profile_path(params[:id])
      end
    else
      flash.now[:error] = "Some errors prohibited the Financial information from being saved"
      render :financial_details, :id=>@profile.id
    end
  end

   private
   def set_selected_tab
     @tab_selected = "new_employee"
   end

   private
  def save_without_validation
    @profile.valid?
    if (@profile.errors.on(:employee_id).nil?)
      @profile.completed = false
      @profile.save(:validate => false)
      flash[:notice] = "Profile Temporarily Saved"
      redirect_to add_qualification_path(@profile.id)
    else
      flash.now[:error] = "Employee ID should be a unique 5 digit number"
      params[:action] == "create" ? (render :template=>'profile/profile_form') : (render :template => 'profile/edit_profile_form')
    end
  end

  def save_with_validation(success)
    if success
      flash[:notice] = 'Profile was successfully saved.'
      redirect_to add_qualification_path(@profile.id)
    else
      yield
    end
  end
  end



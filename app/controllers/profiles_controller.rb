require 'spreadsheet'
class ProfilesController < ApplicationController
  load_and_authorize_resource :class => false


  before_filter :set_selected_tab


  def index
    @profiles = Profile.paginate(
    :order=>'date_of_joining DESC,employee_id DESC',
    :conditions => [ "completed=? and last_day is NULL and employee_id is NOT NULL",params[:incomplete].blank? ],
    :page => params[:page]||1, :per_page => 10)
    @title = params[:incomplete] ? "List of Incomplete Master Data" : "List of Completed Master Data"
    render :template=>'profiles/search_results'
  end

  def search
    @profiles = Profile.find_search_parameters(params[:search_terms]) if params[:search_terms]
    @title = "Search Results"
    render :template=>'profiles/profiles_list'
  end

  def export_search_results
    headers['Content-Type']='application/vnd.ms-excel'
    headers['Content-Disposition']='attachment; filename="search_results.xls"'
    headers['Cache-Control']=''
    @profiles = Profile.find_by_sql("select * from profiles where lower(common_name) like lower('%#{params[:search_terms].to_s}%') or lower(title) like lower('%#{params[:search_terms].to_s}%') or lower(location) like lower('%#{params[:search_terms].to_s}%') or employee_id like '%#{params[:search_terms].to_s}%' ORDER BY date_of_joining DESC")
    render :partial=>'partials/profiles/profile_attributes_for_export', :locals => {:profiles => @profiles},:layout=>false
  end

  def recent
    @profiles = Profile.paginate(:order=>'updated_at DESC', :limit=>10, :page=>params[:page]||1, :per_page=>10)
    @title = "List of Recently Updated Master Data"
    render :template=>'profiles/profiles_list'
  end                            

  def created
    @profiles = Profile.paginate(:order=>'created_at DESC', :limit=>10, :page=>params[:page]||1, :per_page=>10)
    @title = "List of Recently Created Master Data"
    render :template=>'profiles/profiles_list'
  end

  def newly_joined
    @profiles = Profile.paginate(:conditions=>["last_day is NULL and employee_id is NOT NULL"], :order=>'date_of_joining DESC',
     :limit=>10, :page=>params[:page]||1, :per_page=>10)
    @title = "List of Recently Joined Employees"
    render :template=>'profiles/profiles_list'
  end

  private
  def set_selected_tab
    @tab_selected = "master_data"
  end
end
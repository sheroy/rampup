require Rails.root + 'lib/distribution/admin_distribution'

class HomeController < ApplicationController

  before_filter :set_selected_tab

  def index
    authorize! :manage , :all
    @pie_breakdown = []
    @skillset_pie_breakdown = []
    @skill_set = ["Java", ".Net", "Ruby", "Java & .Net", "Ruby & Java", ".Net & Ruby", "Java, Ruby, .Net"]

    begin
      if @current_user.role == "admin" or @current_user.role == "superadmin"
        redirect_to admin_home_path
      end
    rescue
    end
  end

  def admin
    #authorize! :manage , :all
    @head_count_breakdown,@employee_type,@places = Distribution::AdminDistribution.head_count_breakdown
    @new_joinees = Profile.all(:limit=>5, :order=>'date_of_joining desc')
  end

  def head_count_distribution_exporter
    headers['Content-Type']='application/vnd.ms-excel'
    headers['Content-Disposition']='attachment; filename="head_count_distribution.xls"'
    headers['Cache-Control']=''
    @head_count_breakdown, @employee_type, @places = Distribution::AdminDistribution.head_count_breakdown
    render :partial=>'partials/home/breakdowns/head_count', :locals=>{:head_count_breakdown=>@head_count_breakdown, :employee_type=>@employee_type, :places=>@places}, :layout=>false
  end

  private
  def set_selected_tab
    @tab_selected = "home"
  end

end

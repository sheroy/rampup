class AdminController < ApplicationController
  authorize_resource :class => false

  def initialize
    @tab_selected = "distributions"
  end

  def breakdown
    @role_breakdown=HashGenerator.convert_to_hash(Profile.role_and_location_wise_breakdown,"location_id","title")
    @qualification_breakdown=HashGenerator.convert_to_hash(Profile.qualification_category_in_location,"location_id","category")
  end
  def role_exporter
    headers['Content-Type']='application/vnd.ms-excel'
    headers['Content-Disposition']='attachment; filename="role_distribution.xls"'
    headers['Cache-Control']=''
    @role_breakdown= HashGenerator.convert_to_hash(Profile.role_and_location_wise_breakdown,"location","title")
    render :partial => 'partials/home/breakdowns/role',
    :locals=>{:role_breakdown=>@role_breakdown},:layout=>false
  end
  def qualification_distribution_exporter
    headers['Content-Type']='application/vnd.ms-excel'
    headers['Content-Disposition']='attachment; filename="qualification_distribution.xls"'
    headers['Cache-Control']=''
    @qualification_breakdown=HashGenerator.convert_to_hash(Profile.qualification_category_in_location,"location","category")
    render :partial=>'partials/home/breakdowns/qualification',:locals=>{:qualification_breakdown=>@qualification_breakdown},:layout=>false
  end
end

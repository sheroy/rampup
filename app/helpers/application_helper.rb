module ApplicationHelper
  def display_if_not_nil(value)
    value.present? ?  value : "--Not-Set--"
  end
  def month_name(month)
    ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][month-1]
  end
  def custom_date_with_month(date)
    if (date.nil? or date=="--Not-Set--")
      return "--Not-Set--"
    else
      return (date.day.to_s + "-" + month_name(date.month) + "-" + date.year.to_s)
    end
  end
  def display_months_in_years(months)
    unless months.nil?
      years = months/12
      month = months%12
      return "#{years} yr #{month} mth"
    end
    return '--Not-Set--'
  end
  def custom_date_with_month_and_year(date)
    unless date.nil?
      return (month_name(date.month).to_s + "-" + date.year.to_s)
    else
      "Not-Set"
    end
  end
  def check_box_tag_new(name, value = "1", options = {})
    html_options = { "type" => "checkbox", "name" => name, "id" => name, "value" => value }.update(options.stringify_keys)
    unless html_options["check"].nil?
      html_options["checked"] = "checked" if html_options["check"].to_i == 1
    end
    tag :input, html_options
  end
  def convert_years_of_experience_to_years(id)
    profile = Profile.find_by_id(id) rescue nil
    unless profile.nil?
      unless profile.years_of_experience.nil?
        profile.years_of_experience/12.to_i
      else
        return 0
      end
    else
      return 0
    end
  end
  def convert_years_of_experience_to_months(id)
    profile = Profile.find_by_id(id) rescue nil
    unless profile.nil?
      unless profile.years_of_experience.nil?
        profile.years_of_experience%12.to_i
      else
        return 0
      end
    else
      return 0
    end
  end
  def convert_duration_to_years(id)
    experience = Experience.find_by_id(id) rescue nil
    experience.duration/12.to_i unless experience.nil?
  end

  def convert_duration_to_months(id)
    experience = Experience.find_by_id(id) rescue nil
    experience.duration%12.to_i unless experience.nil?
  end

  def title(page_title)
    content_for(:title) {'-'+page_title}
  end

  def from_when(profile)
    assignment = profile.assignments.last_active_assignment
    if assignment.present?
      custom_date_with_month((assignment.first.EndDate.to_date+1))
    else
       custom_date_with_month(profile.DateOfJoining)
    end
  end

  def resource_identification_based_on_home_location(resource)
    	  Location.all.collect.include?(resource.location.name) ?
    	  content_tag("td", link_to(resource.name, show_resource_path(resource.EmployeeID))) :
			  content_tag("td", resource.name)
  end

  def make_current_location_bold(histories)
      return if histories.blank?
      histories.each_with_index do |history,i|
           return i if history.start_date.to_date <= DateTime.now.to_date
      end
  end

  def tab_name_css(tab_name, current_tab)
    if tab_name.nil? || current_tab.nil?
      return "
      "
    end
    hierarchy = [current_tab].flatten.map {|tab| tab.to_sym}
    hierarchy.include?(tab_name.to_sym) ?  "selected" : ""
  end

  def get_profile_id_from_email_id(user)

  end
end

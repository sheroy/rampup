# To change this template, choose Tools | Templates
# and open the template in the editor.

module Calculation
  module ExperienceCalculation
    def experience_outside_tw(months)
      years=(months/12).truncate.to_s
      month=(months%12).to_s
      "Yr: "+years.to_s+" Mn: "+month.to_s
    end
    def experience_in_tw(date_of_joining)
      days = (Date.today.to_date - date_of_joining.to_date).to_int 
      remaining_days = (days%365).to_int
      months = (remaining_days)/30
      "Yr: "+(days/365).to_s+" Mn: "+months.to_s
    end
    def experience_in_tw_in_months(date_of_joining)
      months=0
      unless date_of_joining.nil?
        days = (Date.today.to_date - date_of_joining.to_date).to_int
        months = days/30
      end
      months
    end
    def total_experience(prior_experience,date_of_joining)
       total=prior_experience.to_i + experience_in_tw_in_months(date_of_joining)
      experience_outside_tw(total)
    end
    def custom_date_with_month(date)
    if (date.nil? or date=="--Not-Set--")
      return "--Not-Set--"
    else
      return (date.day.to_s + "-" + month_name(date.month) + "-" + date.year.to_s)
    end
  end
   def month_name(month)
    ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][month-1]
  end
    module_function :experience_outside_tw, :experience_in_tw, :experience_in_tw_in_months,:total_experience,:custom_date_with_month,:month_name
  end
  

end
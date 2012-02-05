module Distribution
  module AdminDistribution
    def head_count_breakdown
      places=["Bangalore","Chennai","Pune","Delhi-Gurgoan"]
      employee_type=["ProfessionalServices","Support","ETG"]
      breakdown=[]
      employee_type.each_with_index do |type,i|
        tmp=places.collect{|location| Profile.head_count_in_location(type,location).length}
        breakdown<<tmp
      end
      return [breakdown,employee_type,places]
    end
    module_function :head_count_breakdown
  end
end

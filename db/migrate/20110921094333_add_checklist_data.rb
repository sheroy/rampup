class AddChecklistData < ActiveRecord::Migration
  def self.up
    education_group = ChecklistGroup.find_or_create_by_description('Education Qualification Certificates', :order=>2)
    visa_group = ChecklistGroup.find_or_create_by_description('Visa', :order=>3)
    group1 = ChecklistGroup.find_or_create_by_description('Photographs', :order=>1)
    tax_group = ChecklistGroup.find_or_create_by_description('Tax', :order=>4)
    dependent_group = ChecklistGroup.find_or_create_by_description('Dependents Information', :order=>5)

    NewJoineeChecklist.find_or_create_by_description('6 Passport size photographs', :group_id=>group1.id,:checklist_id=>1,:report_column_name=>"Passport Photos")
    NewJoineeChecklist.find_or_create_by_description('Class X/ Higher Secondary Certificate along with Mark sheet', :group_id=>education_group.id,:checklist_id=>2,:report_column_name=>"Class X")
    NewJoineeChecklist.find_or_create_by_description('Class XII/ Senior Secondary Certificate along with Mark sheet', :group_id=>education_group.id,:checklist_id=>3,:report_column_name=>"Class XII")
    NewJoineeChecklist.find_or_create_by_description('Graduation/ Degree Certificate along with Mark sheet', :group_id=>education_group.id,:checklist_id=>4,:report_column_name=>"Graduation")
    NewJoineeChecklist.find_or_create_by_description('Latest salary slip or salary certificate', :group_id=>visa_group.id,:checklist_id=>5,:report_column_name=>"Salary Slip")
    NewJoineeChecklist.find_or_create_by_description('relieving letters from all the previous organizations worked in.(Required for immigration purposes)', :group_id=>visa_group.id,:checklist_id=>6,:report_column_name=>"Relieving Letters")
    NewJoineeChecklist.find_or_create_by_description('You offer/appointment letters from all the previous organization worked in. (Required for immigration purposes)', :group_id=>visa_group.id,:checklist_id=>7,:report_column_name=>"Offer Letters")
    NewJoineeChecklist.find_or_create_by_description('Copy of the passport - all pages (in case you have travelled to the US on a H1 visa, then a copy of that)', :group_id=>visa_group.id,:checklist_id=>8,:report_column_name=>"Passport Copies")
    NewJoineeChecklist.find_or_create_by_description('In case of H1: also, the educational evaluation that the company did at that time', :group_id=>visa_group.id,:checklist_id=>9,:report_column_name=>"Educational Evaluation")
    NewJoineeChecklist.find_or_create_by_description('PAN card copy', :group_id=>tax_group.id,:checklist_id=>10,:report_column_name=>"Pan Card")
    NewJoineeChecklist.find_or_create_by_description('Existing PF number', :group_id=>tax_group.id,:checklist_id=>11,:report_column_name=>"PF No.")
    NewJoineeChecklist.find_or_create_by_description('Previous 3 Financial Yar Income Tax Return copies. (Required for immigration purposes)', :group_id=>tax_group.id,:checklist_id=>12,:report_column_name=>"Tax Return")
    NewJoineeChecklist.find_or_create_by_description('Form 16 or a TDS Certificate from last organisation worked in. (Required for calculating Tax for the Financial year)', :group_id=>tax_group.id,:checklist_id=>13,:report_column_name=>"Form 16 or DSD")
    NewJoineeChecklist.find_or_create_by_description('Date of birth details of all dependents', :group_id=>dependent_group.id,:checklist_id=>14,:report_column_name=>"Dependents D.O.B")
  end

  def self.down
    NewJoineeChecklist.destroy_all()
    ChecklistGroup.destroy_all()
  end
end

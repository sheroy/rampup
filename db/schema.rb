# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111228090244) do

  create_table "Account", :id => false, :force => true do |t|
    t.string "AccountID",     :limit => 36, :null => false
    t.string "Name",                        :null => false
    t.string "IndustryId",    :limit => 36
    t.string "SalesLeaderID", :limit => 36
  end

  create_table "Assignment", :id => false, :force => true do |t|
    t.string   "AssignmentID",           :limit => 36, :null => false
    t.string   "ProjectID",              :limit => 36, :null => false
    t.string   "ResourceID",             :limit => 36, :null => false
    t.string   "RoleID",                 :limit => 36, :null => false
    t.datetime "StartDate",                            :null => false
    t.datetime "EndDate",                              :null => false
    t.integer  "Rate",                                 :null => false
    t.integer  "Probability",                          :null => false
    t.integer  "Effort",                               :null => false
    t.boolean  "IsHourlyRate"
    t.boolean  "IsStartDateIndependent",               :null => false
    t.boolean  "IsEndDateIndependent",                 :null => false
    t.boolean  "IgnoreInconsistency",                  :null => false
  end

  create_table "Audit", :id => false, :force => true do |t|
    t.string   "AuditID",    :limit => 36, :null => false
    t.string   "UserName",                 :null => false
    t.datetime "LogTime",                  :null => false
    t.string   "Action",                   :null => false
    t.string   "TableName",                :null => false
    t.string   "ColumnName"
    t.string   "TableKey"
    t.string   "OldValue"
    t.string   "NewValue"
  end

  create_table "Audit_arch", :id => false, :force => true do |t|
    t.string   "AuditID",    :limit => 36,   :null => false
    t.string   "UserName",                   :null => false
    t.datetime "LogTime",                    :null => false
    t.string   "Action",                     :null => false
    t.string   "TableName",                  :null => false
    t.string   "ColumnName"
    t.string   "TableKey"
    t.string   "OldValue",   :limit => 1024
    t.string   "NewValue",   :limit => 1024
  end

  create_table "Country", :id => false, :force => true do |t|
    t.string "CountryID",  :limit => 36, :null => false
    t.string "Name",                     :null => false
    t.string "CurrencyID", :limit => 36, :null => false
  end

  create_table "Currency", :id => false, :force => true do |t|
    t.string  "CurrencyID",       :limit => 36, :null => false
    t.string  "Name",             :limit => 3,  :null => false
    t.integer "ConversionFactor",               :null => false
    t.string  "Symbol",           :limit => 6,  :null => false
  end

  create_table "History", :id => false, :force => true do |t|
    t.string   "HistoryID",    :limit => 36, :null => false
    t.string   "ResourceID",   :limit => 36, :null => false
    t.datetime "StartDate",                  :null => false
    t.string   "locations_id", :limit => 36, :null => false
  end

  add_index "history", ["locations_id"], :name => "fk_history_locations_id"

  create_table "Industry", :id => false, :force => true do |t|
    t.string "IndustryID", :limit => 36, :null => false
    t.string "Name",                     :null => false
  end

  create_table "LEVELS", :id => false, :force => true do |t|
    t.string "LevelsID",     :limit => 36, :null => false
    t.string "Name",                       :null => false
    t.string "TitleLevelID", :limit => 36
  end

  create_table "NonWorkingDay", :id => false, :force => true do |t|
    t.string   "NonWorkingDateID", :limit => 36, :null => false
    t.datetime "NonWorkingDate",                 :null => false
    t.string   "Description"
    t.string   "CountryID",        :limit => 36
  end

  create_table "PaymentStream", :id => false, :force => true do |t|
    t.string   "PaymentStreamID", :limit => 36, :null => false
    t.string   "ProjectID",       :limit => 36, :null => false
    t.integer  "Amount",                        :null => false
    t.datetime "Month"
    t.integer  "Probability"
    t.string   "CountryID",       :limit => 36
  end

  create_table "PlannedRevenue", :id => false, :force => true do |t|
    t.string   "PlannedRevenueID", :limit => 36, :null => false
    t.string   "CountryID",        :limit => 36, :null => false
    t.datetime "Month",                          :null => false
    t.integer  "Amount",                         :null => false
    t.integer  "HeadCount",                      :null => false
  end

  create_table "Project", :id => false, :force => true do |t|
    t.string   "ProjectID",              :limit => 36,   :null => false
    t.string   "AccountID",              :limit => 36,   :null => false
    t.string   "Name",                                   :null => false
    t.string   "Description",            :limit => 1024
    t.string   "CountryID",              :limit => 36,   :null => false
    t.boolean  "IsFixedPrice",                           :null => false
    t.integer  "BlendedRate"
    t.integer  "Probability"
    t.boolean  "IsStillAvailable",                       :null => false
    t.string   "IndustryID",             :limit => 36
    t.string   "SalesLeaderID",          :limit => 36,   :null => false
    t.string   "SponsorID",              :limit => 36,   :null => false
    t.string   "SolutionArchitectID",    :limit => 36
    t.string   "LeadSource"
    t.string   "OpportunityDescription",                 :null => false
    t.string   "Stage"
    t.datetime "CloseDate"
    t.string   "TWOfferingID",           :limit => 36
    t.string   "LocationOfWork"
    t.boolean  "ISHOURLY"
    t.boolean  "IsLeave"
  end

  create_table "ProjectDistributionCountry", :id => false, :force => true do |t|
    t.string "ProjectDistributionCountryID", :limit => 36, :null => false
    t.string "ProjectID",                    :limit => 36, :null => false
    t.string "DistributedCountryID",         :limit => 36, :null => false
  end

  create_table "Resource", :id => false, :force => true do |t|
    t.string   "ResourceID",          :limit => 36,   :null => false
    t.string   "Name",                                :null => false
    t.string   "LevelId",             :limit => 36
    t.string   "LocationID",          :limit => 36
    t.string   "CurrentLocationID",   :limit => 36
    t.datetime "DateOfJoining"
    t.string   "EmployeeID"
    t.boolean  "IsBillable",                          :null => false
    t.datetime "DateOfExit"
    t.boolean  "IsProxy",                             :null => false
    t.string   "Notes",               :limit => 1024
    t.string   "ExchangeID",          :limit => 36
    t.boolean  "IsSalesLeader",                       :null => false
    t.boolean  "IsSolutionArchitect",                 :null => false
    t.boolean  "IsSponsor",                           :null => false
  end

  create_table "Role", :id => false, :force => true do |t|
    t.string  "RoleID", :limit => 36, :null => false
    t.string  "Name",                 :null => false
    t.integer "Rate"
  end

  create_table "TWOffering", :id => false, :force => true do |t|
    t.string "TWOfferingID",   :limit => 36, :null => false
    t.string "TWOfferingName"
  end

  create_table "Title", :id => false, :force => true do |t|
    t.string "TitleID", :limit => 36, :null => false
    t.string "Name",                  :null => false
  end

  create_table "Version", :id => false, :force => true do |t|
    t.integer "Version", :null => false
  end

  create_table "attached_documents", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "profile_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "name"
    t.string   "document_type"
  end

  create_table "branches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checklist_groups", :force => true do |t|
    t.string  "description"
    t.integer "order",       :null => false
  end

  create_table "colleges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string "name"
  end

  create_table "degrees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
  end

  create_table "dependent_passports", :force => true do |t|
    t.string   "name"
    t.string   "relationship"
    t.string   "number"
    t.date     "date_of_issue"
    t.date     "date_of_expiry"
    t.string   "place_of_issue"
    t.string   "nationality"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependent_passports", ["profile_id"], :name => "fk_dependent_passports_profile_id"

  create_table "dependent_visas", :force => true do |t|
    t.string   "status"
    t.datetime "appointment_date"
    t.string   "petition_status"
    t.string   "timeline"
    t.datetime "issue_date"
    t.datetime "expiry_date"
    t.string   "reason"
    t.string   "visa_type"
    t.string   "country"
    t.datetime "date_of_return"
    t.datetime "travel_by"
    t.string   "category"
    t.integer  "dependent_passport_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependent_visas", ["dependent_passport_id"], :name => "fk_dependent_visas_dependent_passport_id"

  create_table "dependents", :force => true do |t|
    t.string   "name"
    t.string   "relationship"
    t.date     "date_of_birth"
    t.integer  "percentage"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  add_index "dependents", ["profile_id"], :name => "fk_dependents_profile_id"

  create_table "employee_checklist_submitteds", :force => true do |t|
    t.integer "profile_id"
    t.integer "new_joinee_checklists_id"
  end

  add_index "employee_checklist_submitteds", ["new_joinee_checklists_id"], :name => "employee_checklist_submitteds_new_joinee_checklists_id_fk"
  add_index "employee_checklist_submitteds", ["profile_id"], :name => "employee_checklist_submitteds_profile_id_fk"

  create_table "experiences", :force => true do |t|
    t.string  "technology"
    t.date    "last_used"
    t.integer "duration"
    t.integer "profile_id"
  end

  add_index "experiences", ["profile_id"], :name => "fk_experiences_profile_id"

  create_table "letterheads", :force => true do |t|
    t.string "office_name",   :null => false
    t.string "template_path", :null => false
  end

  create_table "locations", :force => true do |t|
    t.string  "name",         :limit => 36, :null => false
    t.integer "countries_id",               :null => false
  end

  add_index "locations", ["countries_id"], :name => "fk_locations_countries_id"

  create_table "new_joinee_checklists", :force => true do |t|
    t.string  "description",        :null => false
    t.integer "group_id",           :null => false
    t.integer "checklist_id"
    t.string  "report_column_name"
  end

  add_index "new_joinee_checklists", ["group_id"], :name => "new_joinee_checklists_group_id_fk"

  create_table "passports", :force => true do |t|
    t.string   "number"
    t.date     "date_of_issue"
    t.date     "date_of_expiry"
    t.string   "place_of_issue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nationality"
    t.integer  "profile_id"
  end

  add_index "passports", ["profile_id"], :name => "fk_passports_profile_id"

  create_table "pictures", :force => true do |t|
    t.string  "content_type"
    t.integer "profile_id"
    t.string  "filename"
    t.string  "thumbnail"
    t.integer "size"
    t.integer "width"
    t.integer "height"
    t.integer "parent_id"
  end

  add_index "pictures", ["profile_id"], :name => "fk_pictures_profile_id"

  create_table "profile_pictures", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "parent_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "profile_pictures", ["profile_id"], :name => "fk_profile_pictures_profile_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "common_name"
    t.string   "title"
    t.string   "gender"
    t.string   "marital_status"
    t.string   "permanent_address_line_1"
    t.string   "permanent_address_line2"
    t.string   "permanent_address_line3"
    t.string   "permanent_city"
    t.string   "permanent_state"
    t.string   "permanent_pincode"
    t.string   "temporary_address_line1"
    t.string   "temporary_address_line2"
    t.string   "temporary_address_line3"
    t.string   "temporary_city"
    t.string   "temporary_state"
    t.string   "temporary_pincode"
    t.string   "guardian_name"
    t.integer  "location_id"
    t.date     "date_of_joining"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "transfer_date"
    t.string   "transfer_from"
    t.string   "transfer_to"
    t.string   "employee_id"
    t.date     "date_of_birth"
    t.datetime "last_day"
    t.string   "transferred_abroad"
    t.boolean  "completed"
    t.integer  "years_of_experience"
    t.string   "email_id"
    t.string   "permanent_phone_number"
    t.string   "temporary_phone_number"
    t.string   "personal_email_id"
    t.string   "account_no"
    t.string   "pan_no"
    t.string   "epf_no"
    t.string   "type"
    t.string   "emergency_contact_person"
    t.string   "emergency_contact_number"
    t.string   "blood_group"
    t.string   "access_card_number"
  end

  add_index "profiles", ["location_id"], :name => "fk_profiles_location_id"

  create_table "profiles_backup", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "common_name"
    t.string   "title"
    t.string   "gender"
    t.string   "marital_status"
    t.string   "permanent_address_line_1"
    t.string   "permanent_address_line2"
    t.string   "permanent_address_line3"
    t.string   "permanent_city"
    t.string   "permanent_state"
    t.string   "permanent_pincode"
    t.string   "temporary_address_line1"
    t.string   "temporary_address_line2"
    t.string   "temporary_address_line3"
    t.string   "temporary_city"
    t.string   "temporary_state"
    t.string   "temporary_pincode"
    t.string   "guardian_name"
    t.string   "location"
    t.datetime "date_of_joining"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "transfer_date"
    t.string   "transfer_from"
    t.string   "transfer_to"
    t.string   "employee_id"
    t.datetime "date_of_birth"
    t.datetime "last_day"
    t.string   "transferred_abroad"
    t.boolean  "completed"
    t.integer  "years_of_experience"
    t.string   "email_id"
    t.string   "permanent_phone_number"
    t.string   "temporary_phone_number"
    t.string   "personal_email_id"
    t.string   "account_no"
    t.string   "pan_no"
    t.string   "epf_no"
    t.string   "type"
    t.string   "emergency_contact_person"
    t.string   "emergency_contact_number"
    t.string   "blood_group"
    t.string   "access_card_number"
  end

  create_table "project_technologies", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  add_index "project_technologies", ["project_id"], :name => "fk_project_technologies_project_id"

  create_table "projects", :force => true do |t|
    t.string   "project_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "technology"
  end

  add_index "projects", ["id"], :name => "index_projects_on_id"

  create_table "qualifications", :force => true do |t|
    t.string  "branch"
    t.string  "college"
    t.integer "profile_id"
    t.integer "graduation_year"
    t.string  "degree"
    t.string  "category"
  end

  add_index "qualifications", ["profile_id"], :name => "fk_qualifications_profile_id"

  create_table "relations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", :force => true do |t|
    t.string "name"
    t.string "signature"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technologies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_generators", :force => true do |t|
    t.string   "name"
    t.string   "file_name"
    t.boolean  "document_type"
    t.boolean  "selected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_mappings", :force => true do |t|
    t.string   "name"
    t.string   "table_name"
    t.string   "column_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_salt"
    t.string   "password_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  create_table "visa_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visas", :force => true do |t|
    t.string   "status"
    t.datetime "appointment_date"
    t.string   "petition_status"
    t.string   "timeline"
    t.datetime "issue_date"
    t.datetime "expiry_date"
    t.string   "reason"
    t.string   "visa_type"
    t.string   "country"
    t.datetime "date_of_return"
    t.datetime "travel_by"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  add_index "visas", ["profile_id"], :name => "fk_visas_profile_id"

  add_foreign_key "employee_checklist_submitteds", "new_joinee_checklists", :name => "employee_checklist_submitteds_new_joinee_checklists_id_fk", :column => "new_joinee_checklists_id", :dependent => :delete
  add_foreign_key "employee_checklist_submitteds", "profiles", :name => "employee_checklist_submitteds_profile_id_fk", :dependent => :delete

  add_foreign_key "new_joinee_checklists", "checklist_groups", :name => "new_joinee_checklists_group_id_fk", :column => "group_id", :dependent => :delete

end

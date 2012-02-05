class ConsolidatedMigration < ActiveRecord::Migration
  def self.up
    create_table "Account", :id => false, :force => true do |t|
      t.string "AccountID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.string "IndustryId", :limit => 16
      t.string "SalesLeaderID", :limit => 16
    end
    create_table "Assignment", :id => false, :force => true do |t|
      t.string "AssignmentID", :limit => 16, :null => false
      t.string "ProjectID", :limit => 16, :null => false
      t.string "ResourceID", :limit => 16, :null => false
      t.string "RoleID", :limit => 16, :null => false
      t.datetime "StartDate", :null => false
      t.datetime "EndDate", :null => false
      t.integer "Rate", :limit => 10, :precision => 10, :scale => 0, :null => false
      t.integer "Probability", :null => false
      t.integer "Effort", :null => false
      t.boolean "IsHourlyRate"
      t.boolean "IsStartDateIndependent", :null => false
      t.boolean "IsEndDateIndependent", :null => false
      t.boolean "IgnoreInconsistency", :null => false
    end

    create_table "Audit", :id => false, :force => true do |t|
      t.string "AuditID", :limit => 16, :null => false
      t.string "UserName", :null => false
      t.datetime "LogTime", :null => false
      t.string "Action", :null => false
      t.string "TableName", :null => false
      t.string "ColumnName"
      t.string "TableKey"
      t.string "OldValue"
      t.string "NewValue"
    end

    create_table "Audit_arch", :id => false, :force => true do |t|
      t.string "AuditID", :limit => 16, :null => false
      t.string "UserName", :null => false
      t.datetime "LogTime", :null => false
      t.string "Action", :null => false
      t.string "TableName", :null => false
      t.string "ColumnName"
      t.string "TableKey"
      t.string "OldValue", :limit => 1024
      t.string "NewValue", :limit => 1024
    end

    create_table "Country", :id => false, :force => true do |t|
      t.string "CountryID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.string "CurrencyID", :limit => 16, :null => false
    end

    create_table "Currency", :id => false, :force => true do |t|
      t.string "CurrencyID", :limit => 16, :null => false
      t.string "Name", :limit => 3, :null => false
      t.integer "ConversionFactor", :limit => 10, :precision => 10, :scale => 0, :null => false
      t.string "Symbol", :limit => 6, :null => false
    end

    create_table "History", :id => false, :force => true do |t|
      t.string "HistoryID", :limit => 16, :null => false
      t.string "ResourceID", :limit => 16, :null => false
      t.datetime "StartDate", :null => false
      t.integer "locations_id", :null => false
    end

    create_table "Industry", :id => false, :force => true do |t|
      t.string "IndustryID", :limit => 16, :null => false
      t.string "Name", :null => false
    end

    create_table "LEVELS", :id => false, :force => true do |t|
      t.string "LevelsID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.string "TitleLevelID", :limit => 16
    end

    create_table "locations", :force => true do |t|
      t.string "name", :null => false
      t.integer "countries_id", :null => false
    end

    add_index "locations", ["countries_id"], :name => "fk_locations_countries_id"
    add_index "History", ["locations_id"], :name => "fk_history_locations_id"

    create_table "NonWorkingDay", :id => false, :force => true do |t|
      t.string "NonWorkingDateID", :limit => 16, :null => false
      t.datetime "NonWorkingDate", :null => false
      t.string "Description"
      t.string "CountryID", :limit => 16
    end

    create_table "PaymentStream", :id => false, :force => true do |t|
      t.string "PaymentStreamID", :limit => 16, :null => false
      t.string "ProjectID", :limit => 16, :null => false
      t.integer "Amount", :limit => 10, :precision => 10, :scale => 0, :null => false
      t.datetime "Month"
      t.integer "Probability"
      t.string "CountryID", :limit => 16
    end

    create_table "PlannedRevenue", :id => false, :force => true do |t|
      t.string "PlannedRevenueID", :limit => 16, :null => false
      t.string "CountryID", :limit => 16, :null => false
      t.datetime "Month", :null => false
      t.integer "Amount", :limit => 10, :precision => 10, :scale => 0, :null => false
      t.integer "HeadCount", :null => false
    end

    create_table "Project", :id => false, :force => true do |t|
      t.string "ProjectID", :limit => 16, :null => false
      t.string "AccountID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.string "Description", :limit => 1024
      t.string "CountryID", :limit => 16, :null => false
      t.boolean "IsFixedPrice", :null => false
      t.integer "BlendedRate", :limit => 10, :precision => 10, :scale => 0
      t.integer "Probability"
      t.boolean "IsStillAvailable", :null => false
      t.string "IndustryID", :limit => 16
      t.string "SalesLeaderID", :limit => 16
      t.string "SponsorID", :limit => 16
      t.string "SolutionArchitectID", :limit => 16
      t.string "LeadSource"
      t.string "OpportunityDescription", :null => false
      t.string "Stage"
      t.datetime "CloseDate"
      t.string "TWOfferingID", :limit => 16
      t.string "LocationOfWork"
      t.boolean "ISHOURLY"
      t.boolean "IsLeave"
    end

    create_table "ProjectDistributionCountry", :id => false, :force => true do |t|
      t.string "ProjectDistributionCountryID", :limit => 16, :null => false
      t.string "ProjectID", :limit => 16, :null => false
      t.string "DistributedCountryID", :limit => 16, :null => false
    end

    create_table "Resource", :id => false, :force => true do |t|
      t.string "ResourceID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.string "LevelId", :limit => 16
      t.string "LocationID", :limit => 16
      t.string "CurrentLocationID", :limit => 16
      t.datetime "DateOfJoining"
      t.string "EmployeeID"
      t.boolean "IsBillable", :null => false
      t.datetime "DateOfExit"
      t.boolean "IsProxy", :null => false
      t.string "Notes", :limit => 1024
      t.string "ExchangeID", :limit => 16
      t.boolean "IsSalesLeader", :null => false
      t.boolean "IsSolutionArchitect", :null => false
      t.boolean "IsSponsor", :null => false
    end

    create_table "Role", :id => false, :force => true do |t|
      t.string "RoleID", :limit => 16, :null => false
      t.string "Name", :null => false
      t.integer "Rate", :limit => 10, :precision => 10, :scale => 0
    end

    create_table "TWOffering", :id => false, :force => true do |t|
      t.string "TWOfferingID", :limit => 16, :null => false
      t.string "TWOfferingName"
    end

    create_table "Title", :id => false, :force => true do |t|
      t.string "TitleID", :limit => 16, :null => false
      t.string "Name", :null => false
    end

    create_table "Version", :id => false, :force => true do |t|
      t.integer "Version", :null => false
    end

    create_table "branches", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "colleges", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "countries", :force => true do |t|
      t.string "name"
    end

    create_table "degrees", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "category"
    end

    create_table "dependent_passports", :force => true do |t|
      t.string "name"
      t.string "relationship"
      t.string "number"
      t.date "date_of_issue"
      t.date "date_of_expiry"
      t.string "place_of_issue"
      t.string "nationality"
      t.integer "profile_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dependent_passports", ["profile_id"], :name => "fk_dependent_passports_profile_id"

    create_table "dependent_visas", :force => true do |t|
      t.string "status"
      t.date "appointment_date"
      t.string "petition_status"
      t.string "timeline"
      t.date "issue_date"
      t.date "expiry_date"
      t.string "reason"
      t.string "visa_type"
      t.string "country"
      t.date "date_of_return"
      t.date "travel_by"
      t.string "category"
      t.integer "dependent_passport_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "dependent_visas", ["dependent_passport_id"], :name => "fk_dependent_visas_dependent_passport_id"

    create_table "dependents", :force => true do |t|
      t.string "name"
      t.string "relationship"
      t.date "date_of_birth"
      t.integer "percentage"
      t.string "type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "profile_id"
    end

    add_index "dependents", ["profile_id"], :name => "fk_dependents_profile_id"

    create_table "experiences", :force => true do |t|
      t.string "technology"
      t.date "last_used"
      t.integer "duration"
      t.integer "profile_id"
    end

    add_index "experiences", ["profile_id"], :name => "fk_experiences_profile_id"

    create_table "passports", :force => true do |t|
      t.string "number"
      t.date "date_of_issue"
      t.date "date_of_expiry"
      t.string "place_of_issue"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "nationality"
      t.integer "profile_id"
    end

    add_index "passports", ["profile_id"], :name => "fk_passports_profile_id"

    create_table "pictures", :force => true do |t|
      t.string "content_type"
      t.integer "profile_id"
      t.string "filename"
      t.string "thumbnail"
      t.integer "size"
      t.integer "width"
      t.integer "height"
      t.integer "parent_id"
    end

    add_index "pictures", ["profile_id"], :name => "fk_pictures_profile_id"

    create_table "profiles", :force => true do |t|
      t.string "name"
      t.string "surname"
      t.string "common_name"
      t.string "title"
      t.string "gender"
      t.string "marital_status"
      t.string "permanent_address_line_1"
      t.string "permanent_address_line2"
      t.string "permanent_address_line3"
      t.string "permanent_city"
      t.string "permanent_state"
      t.string "permanent_pincode"
      t.string "temporary_address_line1"
      t.string "temporary_address_line2"
      t.string "temporary_address_line3"
      t.string "temporary_city"
      t.string "temporary_state"
      t.string "temporary_pincode"
      t.string "guardian_name"
      t.string "location"
      t.date "date_of_joining"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.date "transfer_date"
      t.string "transfer_from"
      t.string "transfer_to"
      t.string "employee_id"
      t.date "date_of_birth"
      t.date "last_day"
      t.string "transferred_abroad"
      t.boolean "completed"
      t.integer "years_of_experience"
      t.string "email_id"
      t.string "permanent_phone_number"
      t.string "temporary_phone_number"
      t.string "personal_email_id"
      t.string "account_no"
      t.string "pan_no"
      t.string "epf_no"
      t.string "type"
      t.string "emergency_contact_person"
      t.string "emergency_contact_number"
      t.string "blood_group"
      t.string "access_card_number"
    end

    create_table "project_technologies", :force => true do |t|
      t.integer "project_id"
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "type"
    end

    add_index "project_technologies", ["project_id"], :name => "fk_project_technologies_project_id"

    create_table "projects", :force => true do |t|
      t.string "project_id"
      t.string "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "technology"
    end

    add_index "projects", ["id"], :name => "index_projects_on_id"

    create_table "qualifications", :force => true do |t|
      t.string "branch"
      t.string "college"
      t.integer "profile_id"
      t.integer "graduation_year"
      t.string "degree"
      t.string "category"
    end

    add_index "qualifications", ["profile_id"], :name => "fk_qualifications_profile_id"

    create_table "relations", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "roles", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "states", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "technologies", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "template_generators", :force => true do |t|
      t.string "name"
      t.string "file_name"
      t.boolean "document_type"
      t.boolean "selected"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "template_mappings", :force => true do |t|
      t.string "name"
      t.string "table_name"
      t.string "column_name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "titles", :force => true do |t|
      t.string "name"
    end

    create_table "users", :force => true do |t|
      t.string "username"
      t.string "password_salt"
      t.string "password_hash"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "role"
    end

    create_table "visa_categories", :force => true do |t|
      t.string "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "visas", :force => true do |t|
      t.string "status"
      t.date "appointment_date"
      t.string "petition_status"
      t.string "timeline"
      t.date "issue_date"
      t.date "expiry_date"
      t.string "reason"
      t.string "visa_type"
      t.string "country"
      t.date "date_of_return"
      t.date "travel_by"
      t.string "category"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "profile_id"
    end

    add_index "visas", ["profile_id"], :name => "fk_visas_profile_id"

  end

  def self.down
    `mysqladmin -uroot drop rampup_test`
  end
end

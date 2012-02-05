RampUp::Application.routes.draw do
  resources :template_generators
  match '/' => 'home#index', :as => :home
  match '/admin' => 'home#admin', :as => :admin_home
  match '/home/export/head_count' => 'home#head_count_distribution_exporter', :as => :export_head_count_breakdown
  match '/employee' => 'employee#index', :as => :employee_home
  match '/employee/documents' => 'employee#documents', :as => :employee_documents
  match 'employee/edit' => 'employee#edit', :as => :edit_employee
  match 'employee/update' => 'employee#update', :as => :update_employee
  match '/employee/qualifications' => 'employee#qualifications', :as => :employee_qualifications
  match '/employee/passport' => 'employee#passport', :as => :employee_passport
  match '/employee/financial' => 'employee#financial', :as => :employee_financial
  match '/employee/experience' => 'employee#experience', :as => :employee_experience
  match '/attached_documents/upload' => 'attached_document#upload', :as => :attached_document
  match '/attached_documents/process' => 'attached_document#process_documents', :as => :attached_document_process
  match '/zipped_documents/upload/:id' => 'zipped_document#upload', :as => :zipped_document
  match '/admin/distributions' => 'admin#breakdown', :as => :distributions
  match '/admin/export/role' => 'admin#role_exporter', :as => :export_role_breakdown
  match '/home/export/qualification' => 'admin#qualification_distribution_exporter', :as => :export_qualification_breakdown
  match '/logout' => 'user#logout', :as => :logout, :as => 'logout'
  match '/login' => 'user#login', :as => :login, :as => 'login'
  match '/user/signin' => 'user#signin', :as => :user_singin, :as => 'user_signin'
  match '/profile/passport/new/:id' => 'passport#new', :as => :passport
  match '/profile/passport/show/:id' => 'passport#show', :as => :show_passport
  match '/profile/passport/edit/:id' => 'passport#edit', :as => :edit_passport
  match '/super_admin/manage_fields' => 'super_admin#manage_fields', :as => :manage_fields
  match '/super_admin/manage_admin' => 'super_admin#manage_admin', :as => :manage_admin
  match '/profile/visa/:id' => 'visa#new', :as => :visa
  match '/profile/:profile_id/dependent/:passport_id/visa' => 'visa#add_dependent_visa', :as => :add_dependent_visa
  match '/profile/visa/new/:id' => 'visa#new_visa', :as => :add_new_visa
  match '/profile/:profile_id/passport/:passport_id/visa/:dependent_visa_id' => 'visa#edit_dependent_visa', :as => :edit_dependent_visa
  match 'report/generate' => 'report#generate', :as => :report_generation
  match 'report/people_with_no_pictures/export' => 'report#export_people_with_no_pictures', :as => :export_people_with_no_pictures
  match '/search' => 'search#index', :as => :advanced_search
  match '/search/export' => 'search#export', :as => :export_search_results_to_excel
  match '/search/projects/:search_terms_for_projects' => 'search#search_projects', :as => :projects_search, :via => :get
  match '/distribution/employees/location/:location/experience/:experience' => 'search#distribution_list', :as => :employee_distribution
  match '/distribution/employees/location/:location/role/:role' => 'search#role_distribution_list', :as => :role_distribution
  match '/distribution/employees/category/:category/location/:location' => 'search#qualification_distribution_list', :as => :qualification_distribution
  match '/distribution/employees/location/:location/type/:type' => 'search#head_count_list', :as => :headcount_distribution
  match '/distribution/skillset/location/:location/type/:type/skill/:skills' => 'search#skill_distribution_list', :as => :skillset_distribution
  match '/distribution/skillset/location/:location/skill/:skills/export' => 'search#export_skill_distribution_list', :as => :export_skillset_distribution
  match '/distribution/skillset/export' => 'search#export_distribution_list', :as => :export_distribution
  match '/results/head_count' => 'search#export_head_count_results', :as => :export_head_count_results
  match '/results/qualification' => 'search#export_qualification_results', :as => :export_qualification_results
  match '/results/role' => 'search#export_role_results', :as => :export_role_distribution_results
  match '/results/skill' => 'search#export_skill_distribution_results', :as => :export_skill_distribution_results
  match '/profile/new' => 'profile#new', :as => :new_profile
  match '/profile/save' => 'profile#save', :as => :incomplete_save
  match '/profile/save_as_draft/:id' => 'profile#save_as_draft', :as => :save_as_draft
  match '/profile/show/:id' => 'profile#show', :as => :show_profile
  match '/profile/rm_show/:id' => 'profile#rm_show', :as => :show_profile_rm_view
  match '/profile/resource/:id' => 'profile#resource', :as => :show_resource
  match '/profile/edit/:id' => 'profile#edit', :as => :edit_profile
  match '/profile/complete/:id' => 'profile#complete', :as => :complete_profile
  match '/profile/update/:id' => 'profile#update', :as => :update_profile
  match 'profile/rejoins/:id' => 'profile#rejoins', :as => :employee_rejoins
  match '/upload_spreadsheet/show' => 'upload_spreadsheet#show', :as => :show
  match '/upload_spreadsheet/upload_file' => 'upload_spreadsheet#upload_file', :as => :upload_file
  match '/profiles/export' => 'profiles#export', :as => :export_profiles
  match '/profiles/search/:search_terms' => 'profiles#search', :as => :search, :via => :get
  match '/profiles' => 'profiles#index', :as => :completed_profiles, :via => :get
  match '/profiles/incomplete' => 'profiles#index', :as => :incomplete_profiles, :incomplete => true
  match '/profiles/recent' => 'profiles#recent', :as => :recently_edited_profiles
  match '/profiles/recent' => 'profiles#recent', :as => :recently_created_profiles
  match 'profiles/newjoinees' => 'profiles#newly_joined', :as => :newly_joined_employees
  match '/document' => 'document#index', :as => :document_generation_information
  match '/document/show_upload/' => 'document#show_upload', :as => :document_show_upload
  match '/document/employee_search' => 'document#employee_search', :as => :document_upload_employee_search
  match '/document/show' => 'document#show', :as => :document_generation_show, :via => :get
  match '/document/generate_documents/:query' => 'document#generate_documents', :as => :generate_documents
  match '/document/show_results/' => 'document#show_results', :as => :document_upload_employee_show_results, :via => :get
  match '/immigration' => 'immigration#index', :as => :immigration_information
  match '/immigration/search' => 'immigration#search', :as => :immigration_search, :via => :get
  match '/immigration/profile/:employeeid' => 'immigration#immigration_information', :as => :immigration_information_for_employee
  match '/immigration/export' => 'immigration#export_search_results', :as => :export_immigration_results
  match '/passport/edit/:id' => 'admin_passport#edit', :as => :admin_edit_passport
  match '/passport/new/:id' => 'admin_passport#new', :as => :admin_passport
  match '/passport/dependent/new/:id' => 'admin_passport#add_new_dependent', :as => :add_new_dependent_passport
  match '/passport/dependent/edit/:id/:dependent_passport_id' => 'admin_passport#edit_dependent', :as => :edit_dependent_passport
  match '/passport/dependent/delete/:id/:dependent_passport_id' => 'admin_passport#delete_dependent', :as => :delete_dependent_passport
  match '/qualification/add/:profile_id' => 'qualification#add', :as => :add_qualification
  match '/qualification/save/:profile_id' => 'qualification#save', :as => :save_qualification
  match '/qualification/validate/:profile_id' => 'qualification#validate', :as => :validate_qualification
  match '/insurance/new_life_insurance/:id' => 'insurance#new_life_insurance', :as => :add_insurance
  match '/insurance/show_insurance' => 'insurance#show_insurance', :as => :show_insurance
  match '/insurance/:id/edit_life_insurance/:life_insurance_id' => 'insurance#edit_life_insurance', :as => :edit_life_insurance
  match '/insurance/:id/delete_life_insurance/:life_insurance_id' => 'insurance#delete_life_insurance', :as => :delete_life_insurance
  match '/insurance/:profile_id/edit_medical_insurance/:id' => 'insurance#edit_medical_insurance', :as => :edit_medical_insurance
  match '/insurance/:profile_id/delete_medical_insurance/:id' => 'insurance#delete_medical_insurance', :as => :delete_medical_insurance
  match '/newjoineechecklist/show/:id' => 'new_joinee_checklist#show', :as => :show_new_joinee_checklist
  match '/newjoineechecklist/save/:id' => 'new_joinee_checklist#save', :as => :save_new_joinee_checklist
  match '/experience/add/:profile_id' => 'experience#add', :as => :add_experience
  match '/picture/get' => 'picture#get', :as => :upload_picture
  resources :profile
  resources :visa_categories
  #match ':controller/:action/.:format' => '#index'
  #match '/:controller(/:action(/:id))'
end

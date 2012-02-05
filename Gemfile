source :gemcutter
gem "rails", "= 3.2.1"
#gem "mysql2", "0.2.7"
gem "mysql2", "0.3.11"

#Introduced gems for asset pipeline
gem 'json'
gem 'sass'
gem 'coffee-script'
gem 'jquery-rails'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier' 
end

# bundler requires these gems in all environments
gem "rubyzip"
gem "spreadsheet"
gem "eycap"
gem "childprocess", "= 0.2.0"
gem "mini_magick"
gem "foreigner"
gem "rubycas-client-rails"
gem "rubycas-client", "=2.2.1"  # There is an open issue for higher versions: https://github.com/rubycas/rubycas-client-rails/issues/6
gem "cancan"
gem "will_paginate", "~> 3.0.2"

gem "pdfkit"
gem "wkhtmltopdf-binary"
gem "paperclip"

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
end

group :development, :test do
  gem "rspec-rails"
end

group :cucumber do
  gem 'cucumber'
  gem 'cucumber-rails'
  gem "gherkin"
  gem 'capybara'
  gem "pickle"
  gem "database_cleaner"
  gem 'launchy'    # So you can do Then show me the page
  gem 'capybara-webkit'
end

group :qa do
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :production do
  gem 'capistrano'
end
  gem 'capistrano-ext'

gem 'factory_girl', :groups => [:test, :cucumber]
gem 'simplecov', :groups => [:test, :cucumber]
gem 'populator', :groups => [:development, :qa]
gem 'faker', :groups => [:development, :qa]


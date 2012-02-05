class RecreateConsistentLocationsTable < ActiveRecord::Migration
  def self.up

    Country.find_or_create_by_name(:name=>'China')
    Country.find_or_create_by_name(:name=>'Canada')
    Country.find_or_create_by_name(:name=>'Germany')
    Country.find_or_create_by_name(:name=>'Sweden')
    Country.find_or_create_by_name(:name=>'UK')
    Country.find_or_create_by_name(:name=>'India')
    Country.find_or_create_by_name(:name=>'Brazil')
    Country.find_or_create_by_name(:name=>'US')
    Country.find_or_create_by_name(:name=>'Australia')

    execute 'ALTER TABLE locations AUTO_INCREMENT = 1;'

    Location.find_or_create_by_name('Bangalore 1', :countries_id => 6)
    Location.find_or_create_by_name('Chennai', :countries_id => 6)
    Location.find_or_create_by_name('Gurgaon', :countries_id => 6)
    Location.find_or_create_by_name('Pune', :countries_id => 6)
    Location.find_or_create_by_name('Porto Alegre', :countries_id => 7)
    Location.find_or_create_by_name('London', :countries_id => 5)
    Location.find_or_create_by_name('Atlanta', :countries_id => 8)
    Location.find_or_create_by_name('Bangalore 2', :countries_id => 6)
    Location.find_or_create_by_name('Beijing', :countries_id => 1)
    Location.find_or_create_by_name('Brisbane', :countries_id => 9)
    Location.find_or_create_by_name('Calgary', :countries_id => 2)
    Location.find_or_create_by_name('Chicago', :countries_id => 8)
    Location.find_or_create_by_name('Delhi', :countries_id => 6)
    Location.find_or_create_by_name('Hamburg', :countries_id => 3)
    Location.find_or_create_by_name('Manchester', :countries_id => 5)
    Location.find_or_create_by_name('Melbourne', :countries_id => 9)
    Location.find_or_create_by_name('Nashville', :countries_id => 8)
    Location.find_or_create_by_name('New York', :countries_id => 8)
    Location.find_or_create_by_name('NY-NJ Home Offices', :countries_id => 8)
    Location.find_or_create_by_name('Ohio', :countries_id => 8)
    Location.find_or_create_by_name('Perth', :countries_id => 9)
    Location.find_or_create_by_name('San Francisco', :countries_id => 8)
    Location.find_or_create_by_name('Stockholm', :countries_id => 4)
    Location.find_or_create_by_name('Sunnyvale', :countries_id => 8)
    Location.find_or_create_by_name('Sydney', :countries_id => 9)
    Location.find_or_create_by_name('Toronto', :countries_id => 2)
    Location.find_or_create_by_name('US Corp', :countries_id => 8)
    Location.find_or_create_by_name('X\'ian', :countries_id => 1)
  end

  def self.down
    Location.delete_all
  end
end

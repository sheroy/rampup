class LocationNameToLocationId < ActiveRecord::Migration
  def self.up
    create_table "locations", :force => true do |t|
      t.string "name", :limit => 36, :null => false
      t.integer "countries_id", :null => false
    end

    create_backup_query = "CREATE TABLE profiles_backup LIKE profiles;"
    copy_data_query = "insert into profiles_backup select * from profiles;"
    ActiveRecord::Base.connection.execute(create_backup_query)
    ActiveRecord::Base.connection.execute(copy_data_query)

    profiles = Profile.all(:select => "id,location")
    data_hash = {}
    profiles.each do |p|
      data_hash[p.read_attribute('id')] = p.read_attribute('location') unless p.read_attribute('location').nil?
    end

    rename_column(:profiles, :location, :location_id)
    change_column(:profiles, :location_id, :integer)
    add_index "locations", ["countries_id"], :name => "fk_locations_countries_id"
    add_index "profiles", ["location_id"], :name => "fk_profiles_location_id"

    data_hash.each do |id,location_name|
      new_location = Location.find_by_name(location_name)
      if(new_location == nil)
        Location.create(:name => location_name, :countries_id => 2)
        new_location = Location.find_by_name(location_name)
      end
      query = "UPDATE profiles SET location_id = #{new_location.id} where id = #{id}"
      ActiveRecord::Base.connection.execute(query)
    end
  end

  def self.down
    create_table "Location", :force => true do |t|
      t.string "Name", :limit => 36, :null => false
      t.string "CountryID", :limit => 36, :null => false
    end

    rename_column(:profiles, :location_id, :location)
    change_column(:profiles, :location, :string)

    drop_table "locations"
  end
end

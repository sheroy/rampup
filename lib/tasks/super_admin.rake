namespace :db do
  task :super_admin, :name, :needs => :environment do |t, args|
    if(args.name.nil?)
      abort "** Please use format rake db:superadmin[name1-name2-etc] **"
    else
      names = args.name.split("-")
      names.each do |name|
        puts "Creating superadmin #{name}"
        user = User.find_by_username(name)
        if(user.nil?)
          User.create(:username => name, :role => "superadmin")
        else
          User.update(user.id, {:role => "superadmin"})
        end
      end
    end
  end
end
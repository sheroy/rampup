require 'csv'
module CSVAdapter
  class PictureExporter
    
    def initialize(profiles)
      @profiles = profiles
    end

    def to_csv
      csv_stream do |csv|
        csv << ["People with No Pictures"]
        csv << []
        populate_csv_with_profiles(csv)
      end
    end

    def populate_csv_with_profiles(csv)
      @profiles.each do |profile|
        csv << [profile.employee_id,profile.name,"#{profile.email_id}@thoughtworks.com", profile.location_id]
      end
    end

    def csv_stream
      stream = out_stream
      CSV::Writer.generate(stream) do |csv|
        yield(csv)
      end
      stream
    end

    def out_stream
      String.new
    end

  end
end

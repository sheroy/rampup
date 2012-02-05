class DataFile
  def self.generate_path upload
    File.join("public/system/templates", upload['datafile'])
  end

  def self.save(upload)
    File.open(generate_path(upload), "w") { |f|
      uploaded_file = File.open("tmp/" + upload['datafile'], 'r+')
      f.write(uploaded_file.read)
      uploaded_file.close()
    }
  end
end

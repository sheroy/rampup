require 'pathname'
require 'zip/zip'
require 'zip/zipfilesystem'

module TemplateEngine
  def generate_mandatory_documents(file_names, id, zip_name)
    files_to_be_zipped=[]
    @profile_info = TemplateMapping.get_profile_data(id)
    @beneficiary_info = TemplateMapping.get_beneficiary_info_for_life_insurance(id)
    @dependent_info = TemplateMapping.get_beneficiary_info_for_medical_insurance(id)
    qualification=TemplateMapping.get_qualification_data(id)
    @qualification_info = qualification.collect(&:RAMPUP_QUALIFICATION).join(',')
    @branch_info = qualification.collect(&:RAMPUP_BRANCH).join(',').gsub(/&/,'and')
    @spouse_info = TemplateMapping.get_spouse_name(id)

    find_and_replace_placeholders_with_value(file_names).each_with_index do |content, i|
      files_to_be_zipped<<"#{file_names[i].sub(/.*\//, '').sub(/.xml/, "")}.doc"
      File.open("#{Rails.root}/tmp/#{file_names[i].sub(/.*\//, '').sub(/.xml/, "")}.doc", 'w') {|f| f.write(content) }
    end  
    bundle(files_to_be_zipped,"#{Rails.root}/public/system/templates",zip_name,zip_name)
  end

  def generate_optional_documents(file_names, id, zip_name, authority_name)
    files_to_be_zipped=[]
    @profile_info = TemplateMapping.get_profile_data(id)
    @beneficiary_info = TemplateMapping.get_beneficiary_info_for_life_insurance(id)
    @dependent_info = TemplateMapping.get_beneficiary_info_for_medical_insurance(id)
    qualification=TemplateMapping.get_qualification_data(id)
    @qualification_info = qualification.collect(&:RAMPUP_QUALIFICATION).join(',')
    @branch_info = qualification.collect(&:RAMPUP_BRANCH).join(',').gsub(/&/,'and')
    @spouse_info = TemplateMapping.get_spouse_name(id)
    @signature = TemplateMapping.get_signature(authority_name)
   
    find_and_replace_placeholders_with_value(file_names).each_with_index do |content, i|
      htm_filepath = "#{Rails.root}/tmp/#{file_names[i].sub(/.*\//, '').sub(/.htm/, "").sub(/.html/, "")}.htm"
      htm_filename = htm_filepath.sub(/.*\//, '')
      File.open(htm_filepath, 'w') {|f| f.write(content) }
      pdf_filepath = convert_htm_to_pdf(htm_filepath)
      files_to_be_zipped << pdf_filepath
      bundle(files_to_be_zipped,"#{Rails.root}/public/system/templates",zip_name,zip_name)
    end
  end

  def find_and_replace_placeholders_with_value(file_names)
    word_file_contents = []
    file_names.each do |file_name|
      file_contents = contents_of_file(file_name)
      place_holders = find_place_holders(file_contents)

      place_holders.each do |place_holder|
        file_contents = replace_placeholder_value(place_holder, file_contents)
      end
      word_file_contents << file_contents
    end
    word_file_contents
  end

  def replace_placeholder_value(place_holder, file_contents)
    return replace_first_occurrence_of_place_holder_with_data(file_contents, place_holder,@qualification_info) if place_holder =~ /QUALIFICATION/
      return replace_first_occurrence_of_place_holder_with_data(file_contents, place_holder,@branch_info) if place_holder =~ /BRANCH/
      return replace_first_occurrence_of_place_holder_with_data(file_contents, place_holder,DateTime.now.to_date.strftime('%d-%m-%Y')) if place_holder =~ /DATE/
      array_to_be_looped = find_the_array_to_be_looped(place_holder)

    array_to_be_looped.each do |p|
      file_contents = replace_first_occurrence_of_place_holder_with_data(file_contents, place_holder, p.send(place_holder))
    end
    return replace_all_occurrences_of_place_holder_with_data(file_contents, place_holder, "")
  end

  def find_the_array_to_be_looped(place_holder)
    return @signature if place_holder =~/SIGNATURE/
      return @beneficiary_info if place_holder =~/BENEFICIARY/
      return @dependent_info if place_holder =~/DEPENDENT/
      return @spouse_info  if place_holder =~/SPOUSE/
      return @profile_info
  end

  def contents_of_file(file_name)
    return File.read(file_name)
  end

  def find_place_holders(file_contents)
    return file_contents.scan(/\RAMPUP_\w*/)
  end



  def replace_first_occurrence_of_place_holder_with_data(file_contents, placeholder, data)
    #A regular expression designed to capture any string containing only UPPERCASE characters (including underscores) followed by "_DO" and ending in I, J, E or B
    #This is to capture rampup fields which specify a date, i.e. DOB (Date of Birth), DOI (Date of Issue), etc
    reg_exp = /RAMPUP[A-Z_]*_DO(I|E|J|B)/
      data_str =  reg_exp.match(placeholder)  ? data.to_date.strftime('%d-%m-%Y') : data.to_s
    file_contents.sub(placeholder, data_str)
  end

  def replace_all_occurrences_of_place_holder_with_data(file_contents, placeholder, data)
    return file_contents.gsub(placeholder, data.to_s) if placeholder=~/DEPENDENT/ or placeholder=~/BENEFICIARY/ or placeholder=~/SPOUSE/
      return file_contents
  end

  def bundle(filenames, path_name,name ="New Hire Docs", set="New Hire Docs", file_directory = "#{Rails.root}/tmp/")
    bundle_filename = "#{path_name}/#{name}.zip"
    if File.exists?(bundle_filename)
      File.delete(bundle_filename)
    end
    Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
      |zipfile|
      filenames.collect {
        |file|
        filename = file.sub(/.*\//, '')
        zipfile.add( "#{set}/#{filename}", "#{file_directory + file}")
      }
    }
    File.chmod(0644, bundle_filename)
  end

  def convert_htm_to_pdf htm_filename
    htm = File.new(htm_filename)
    pdf_filename = "#{htm_filename.sub(/.*\//, '').sub(/.htm/, "").sub(/.html/, "")}.pdf"
    kit = PDFKit.new(htm.read, :page_size => 'A4', :margin_top => "1.00in", :margin_bottom => "0.80in", :margin_left => "0.33in", :margin_right => "0.33in")
    kit.stylesheets << 'doc/templates/html2pdf.css'
    kit.to_pdf
    kit.to_file("#{Rails.root}/tmp/" + pdf_filename)
    pdf_filename
  end

  def apply_letter_head_to_pdf(pdf_filename, template_filename)
    target_filename = 'letterhead_' + Pathname.new(pdf_filename).basename.to_s
    successful = system "pdftk '#{Rails.root}/tmp/#{pdf_filename}' background '#{template_filename}' output '#{Rails.root}/tmp/#{target_filename}'"
    if not successful
      raise 'Unable to execute pdftk'
    end
    target_filename
  end

  module_function :contents_of_file, :find_place_holders, :replace_first_occurrence_of_place_holder_with_data,
    :replace_all_occurrences_of_place_holder_with_data,:bundle, :find_and_replace_placeholders_with_value, :replace_placeholder_value, :find_the_array_to_be_looped, :convert_htm_to_pdf,
    :apply_letter_head_to_pdf,:generate_optional_documents, :generate_mandatory_documents
end

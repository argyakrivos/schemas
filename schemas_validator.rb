require "nokogiri"
require "colorize"

SCHEMA_FILE = "schema.xsd"

def validate(folder, xsd_file, xml_file)
  Dir.chdir(folder) do
    errors = []
    begin
      xsd = Nokogiri::XML::Schema(File.read(xsd_file))
      errors.push(*xsd.errors) if xsd.errors.any?
    rescue Nokogiri::XML::SyntaxError => e
      errors << e.message
    end

    begin
      doc = Nokogiri::XML(File.read(xml_file))
      errors.push(*doc.errors) if doc.errors.any?
    rescue Nokogiri::XML::SyntaxError => e
      errors << e.message
    end

    begin
      xsd.validate(doc).each do |error|
        errors << error.message
      end
    rescue NoMethodError
      # no need to log this one
    end

    errors
  end
end

# for all directories
total_files = 0
valid_files = 0
skipped_files = 0
invalid_files = 0

Dir.glob("**/*/") do |folder|
  puts "Going through #{folder}"
  xsd_file = "#{folder}#{SCHEMA_FILE}"
  if File.exists? xsd_file
    # all xml files
    xml_files = Dir.glob("#{folder}*.xml")
    if xml_files.empty?
      skipped_files += 1
      puts "   Skipping #{xsd_file} - could not find any XML files to validate against".colorize(:yellow)
      next
    end
    total_files += 1
    xml_files.each do |xml_file|
      total_files += 1
      print "   Validating #{xml_file} against #{xsd_file} ... ".colorize(:cyan)
      errors = validate(folder, File.basename(xsd_file), File.basename(xml_file))
      if errors.empty?
        valid_files += 1
        puts "valid!".colorize(:green)
      else
        invalid_files += 1
        puts "invalid!".colorize(:red)
        errors.each do |msg|
          puts "      #{msg}".colorize(:red)
        end
      end
    end
  end
end

info = "\n#{total_files} files ("
info << "#{invalid_files} invalid".colorize(:red) << ", " if invalid_files > 0
info << "#{skipped_files} skipped".colorize(:yellow) << ", " if skipped_files > 0
info << "#{valid_files} valid".colorize(:green) << ")"
puts info

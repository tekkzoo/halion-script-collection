#!/usr/bin/ruby

require 'pathname' 

usagestring = "usage: \n ruby HALionFileListCreator.rb \"[path of directory with samples]\" \"[outputfilename.lua]\" \n example: \n ruby HALionFileListCreator.rb \"/user/Documents/Steinberg/HALion/Recordings/\" \"/user/myBuiltinSamples.lua\""

if (ARGV[0] == nil && ARGV[1] == nil) || ARGV[0] == "--help" then
    puts usagestring
    exit 1
elsif ARGV[0] == nil || ARGV[1] == nil then
    puts "ERROR: only one parameter provided, please provide all required arguments to the script"
    puts usagestring
    exit 1 
end

scanPath = Pathname.new(ARGV[0])
outputFilePath = ARGV[1]
##get directory path to scan, use relative path from scriptlocation

#cleanup old file
if File.exist?(outputFilePath) then
    File.delete(outputFilePath)
end

#create output script file and open for writing
File.new(outputFilePath, "w+")
fileListTableScript = File.open(outputFilePath, "w+")

#change working dir to scan directory and create find list containing only files, no directories:
Dir.chdir(scanPath)
 fileList = Dir.glob("*").select {|f| File.file?(f)}

# some notes regarding arrays (like a tables in LUA):
# puts  fileList.take(1) #take first element of array
# puts  fileList.drop(1) #drop first element of array

# define searchpath variable
fileListTableScript.write("sampleSearchPath = "+scanPath.to_s+"\n")
# create file list table
fileListTableScript.write("-- The actual table with file/path pairs")
fileListTableScript.write("builtInSamples = {\n")
#iterate over files and create a table with name and path for each
fileList.drop(1).each do |file|
    # fileListTableScript.write(""+file+"\n")
        fileListTableScript.write(
        "   { name = "+File.basename(file)+", path = sampleSearchPath.."+File.basename(file)+" },\n"
        )
end
fileListTableScript.write("}\n")

fileListTableScript.write("-- create table with the sample names\n")
fileListTableScript.write("function getSampleNames()\n")
fileListTableScript.write("     sampleNames = {}\n")
fileListTableScript.write("     for i, sample in ipairs(builtInSamples) do\n")
fileListTableScript.write("         sampleNames[i] = sample.name\n")
fileListTableScript.write("     end\n")
fileListTableScript.write("end\n")

fileListTableScript.write("getSampleNames()\n")

fileListTableScript.write("--use a construct similar to the example below and connect it to your dropdown on the macropage:\n")
fileListTableScript.write("--  defineParameter(\"sampleSelect\", \"sampleSelect\", 1, sampleNames, function() setSamplePath(builtInSamples[sampleSelect]) end)\n")
fileListTableScript.write("--  setSamplePath(selectedSample) \n")
fileListTableScript.write("--      sampleZoneVar:setParameter(\"SampleOsc.Filename\", selectedSample.path)\n")
fileListTableScript.write("--  end\n")
puts "Done :) now paste the contents of "+outputFilePath+" to your HALion Script LUA file"
exit 0

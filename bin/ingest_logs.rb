require 'ut2004stats'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ingest_logs.rb [options]"

  opts.on("-fFORMAT", "--format=FORMAT", "Log format to be read. Only supported format is 'olstat'") do |f|
    options[:format] = f
  end
end.parse!

unless options[:format]
  puts "No log format specified! Will try to infer log format"
  options[:format] = "olstats"
end

case options[:format]
when "olstats"
  require 'ut2004stats/parser/OLStats'
  parser = UT2004Stats::Parser::OLStats.new
end
parser.parse( ARGF.read )

#!/usr/bin/env ruby

require 'ut2004stats/parser/OLStats'
require 'ut2004stats/database/memory'
require 'ut2004stats/output/html'
require 'ut2004stats/pretty'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: render_html.rb [options]"
end.parse!

parser = UT2004Stats::Parser::OLStats.new
db = UT2004Stats::Database::Memory.new
outputter = UT2004Stats::Output::HTML.new

parser.parse( ARGF.read, db )

outputter.output( db, "output/" )

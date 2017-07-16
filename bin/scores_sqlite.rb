#!/usr/bin/env ruby

require 'ut2004stats/parser/OLStats'
require 'ut2004stats/database/sqlite3'

parser = UT2004Stats::Parser::OLStats.new
db = UT2004Stats::Database::SQLite3.new "tmp/test.db"
parser.parse( ARGF.read, db )

#db.scores.map {|p,s| [p.name,s] }.to_h.each {|p,s| puts "#{p}, #{s}"}

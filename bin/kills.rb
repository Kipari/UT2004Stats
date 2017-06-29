#!/usr/bin/env ruby

require 'ut2004stats/parser/OLStats'
require 'ut2004stats/database/memory'

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: kd.rb [options]"

  opts.on("-b", "--bots", "Include bots and kills of/by bots in stats") do |b|
    options[:bots] = b
  end
end.parse!

parser = UT2004Stats::Parser::OLStats.new
db = UT2004Stats::Database::Memory.new
parser.parse( ARGF.read, db )

if options[:bots]
  players = db.players
else
  players = db.players.select { |id,p| p.bot? == false}
end
  
output = players.map do |id,p|
  kills = db.kills.select { |k| k.killer == id and players.include? k.victim }
  deaths = db.kills.select { |k| k.victim == id and players.include? k.killer }
  { :name => p.name, :kills => kills.count, :deaths => deaths.count, :id => id }
end

output.each { |p| puts "#{p[:name]}, #{p[:kills]}, #{p[:deaths]}, #{p[:id]}" }

#!/usr/bin/env ruby

require 'ut2004stats'

ps = UT2004Stats::Player.where(bot: false)
pscores = ps.map{|p| [p.name, p.scores.inject(0) { |sum, s| sum + s.score }]}.to_h
pscores.each do |k,v|
  puts "#{k}\t#{v}"
end

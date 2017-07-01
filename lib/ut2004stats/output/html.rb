require 'ut2004stats/events'
require 'ut2004stats/game'

require 'erb'

module UT2004Stats
  module Output
    class HTML
      def output ( db, out_dir )
        dir = File.dirname(__FILE__)

        # Player data retrieval
        players = db.players.select { |id, p| p.bot? == false }
        player_data = players.map do |id, player|
	  { :name => player.name,
            :kill_count => db.kills.select { |k| k.killer_id == id and players.include? k.victim_id }.count,
            :death_count => db.kills.select { |k| k.victim_id == id and players.include? k.killer_id }.count,
            :match_count => db.matches.select { |m| m.players.include?(id) }.count }
        end
        
        sort_by_match_count = -> (a,b) { b[:match_count] <=> a[:match_count] }
        player_data.sort!( & sort_by_match_count )
          
        File.open("#{out_dir}/index.html", 'w+') do |f|
          vars = binding
          vars.local_variable_set(:player_data, player_data)
          f << ERB.new(File.read "#{dir}/html/index.erb").result(vars)
        end
      end
    end
  end
end
      

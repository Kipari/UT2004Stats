require 'ut2004stats'

require 'erb'
require 'fileutils'

module UT2004Stats
  module Output
    class HTML
      def output ( out_dir )
        dir = File.dirname(__FILE__)

        # Player data retrieval
        players = Player.where(bot: false)

        player_data = players.map do |player|
	  { :id => player.p_id,
            :name => player.name,
            :kill_count => player.kills.count,
            :death_count => player.deaths.count,
            :match_count => player.scores.count }
        end
        
        sort_by_match_count = -> (a,b) { b[:match_count] <=> a[:match_count] }
        player_data.sort!( & sort_by_match_count )
          
        File.open("#{out_dir}/index.html", 'w+') do |f|
          vars = binding
          vars.local_variable_set(:player_data, player_data)
          f << ERB.new(File.read "#{dir}/html/index.erb").result(vars)
        end

        FileUtils.cp("#{dir}/html/style.css", out_dir)
      end
    end
  end
end
      

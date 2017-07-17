require 'ut2004stats'

require 'erb'
require 'fileutils'

module UT2004Stats
  module Output
    class HTML
      def initialize
        @dir = File.dirname(__FILE__)
      end
      
      def output ( out_dir )
        gen_index out_dir
        gen_matches out_dir

        FileUtils.cp("#{@dir}/html/style.css", out_dir)
      end

      def gen_index ( out_dir )
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
          f << ERB.new(File.read "#{@dir}/html/index.erb").result(vars)
        end
      end

      def gen_matches ( out_dir )
        FileUtils.mkdir_p("#{out_dir}/match")

        matches = Match.all

        matches.each do |match|
          file_path = "#{out_dir}/match/#{match.id}.html"
          if (File.file?(file_path) and
              File::Stat.new(file_path).ctime > match.updated_at) then
            next
          end
          File.open(file_path, 'w+') do |f|
            vars = binding
            f << ERB.new(File.read "#{@dir}/html/match.erb").result(vars)
          end
        end
      end
    end
  end
end
      

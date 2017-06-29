require 'date' # for interprting timestamps
require_relative '../events'

module UT2004Stats
  module Parser
    class OLStats
      def parse ( log, db )
        log.split("\n").each do |line|
          entry = line.split "\t"
          next unless entry.length > 1
          timestamp = entry[0].to_f
          case entry[1].to_sym
          when :S # Score
            event = ScoreEvent.new( timestamp )
            event.player_seqnum = entry[2].to_i
            event.score = entry[3].to_f
            event.reason = entry[4]

            db.score( event )
          when :NG # New Game
            event = NewGameEvent.new( timestamp )
            event.start_time = Date.parse( entry[2] )
            event.map_file = entry[4]
            event.map = entry[5]
            event.map_creator = entry[6]
            event.gamemode = entry[7]
            event.params = entry[8]
            
            db.new_game( event )
          when :SI # Server Initialization
            event = ServerInitEvent.new( timestamp )
            event.server_name = entry[2]
            event.params = entry[7]

            db.server_init( event )
          when :C # Connect (player)
            event = PlayerConnectEvent.new( timestamp )
            event.player_seqnum = entry[2].to_i
            event.other_string = entry[3]
            event.player_name = entry[4]
            event.cdkey = entry[5]

            db.player_connect( event )
          when :G # Game? (name changes are included here)
            case entry[2].to_sym
            when :NameChange
              event = PlayerNameChangeEvent.new( timestamp )
              event.player_seqnum = entry[3].to_i
              event.new_name = entry[4]
              
              db.player_name_change( event )
            end
          when :SG # ?
          when :PS # Player String?
            event = PlayerStringEvent.new( timestamp )
            event.player_seqnum = entry[2].to_i
            event.address = entry[3]
            event.netspeed = entry[4]
            event.player_uid = entry[5]
            
            db.player_string( event )
          when :BI # ?
          when :P # Something with multikills and first bloods (also combos)
            event = SpecialKillEvent.new( timestamp )
            event.player_seqnum = entry[2].to_i
            event.type = entry[3]

            db.special_kill( event )
          when :K # Kill
            event = KillEvent.new( timestamp )
            event.player_seqnum = entry[2].to_i
            event.victim_seqnum = entry[4].to_i
            event.dmgtype = entry[3]
            event.weapon = entry[5]

            db.kill( event )
          when :PP # ?
          when :EG # End Game
          end
        end
      end
    end
  end
end

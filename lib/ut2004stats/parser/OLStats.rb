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
            event.player_seqnum = entry[2]
            event.score = entry[3].to_f
            event.reason = entry[4]

            db.score( event )
          when :NG # New Game
            event = NewGameEvent.new( timestamp )
            event.time = Date.parse( entry[2] )
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
          when :G # Game? (name changes are included here)
            game_event_type = entry[2].to_sym

            case game_event_type
            when :NameChange
              event = PlayerNameChangeEvent.new ( timestamp )
              event.player_seqnum = entry[3].to_i
              event.new_name = entry[4]
              
              db.player_name_change( event )
            end
          when :SG # ?
          when :PS # ?
          when :BI # ?
          when :P # Something with multikills
          when :K # Kill
          when :PP # ?
          when :EG # End Game
          end
        end
      end
    end
  end
end

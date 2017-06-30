require 'date' # for interprting timestamps
require_relative '../events'

module UT2004Stats
  module Parser
    class OLStats
      def initialize
        @seqnums = {}
        @temp_players = {}
      end
      
      def parse ( log, db )
        # gsub converts DOS-style line breaks to Unix-style line breaks
        log.gsub(/\r/,"").split("\n").each do |line|
          entry = line.split("\t")
          next unless entry.length > 1
          timestamp = entry[0].to_f
          case entry[1].to_sym
          when :S # Score
            player_seqnum = entry[2].to_i
            
            event = ScoreEvent.new( timestamp )
            event.player_id = @seqnums[player_seqnum]
            event.score = entry[3].to_f
            event.reason = entry[4]

            db.score( event )
          when :NG # New Game
            event = NewGameEvent.new( timestamp )
            event.start_time = DateTime.parse( entry[2] )
            event.map = entry[4]
            event.map_name = entry[5]
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
            player_seqnum = entry[2].to_i

            player = Player.new
            player.id = entry[4]
            player.cdkey = entry[5]

            # If a player has no CD-key, he must be a bot
            unless player.cdkey
              player.name = "[BOT] #{player.id}"
              player.bot = true
              event = NewPlayerEvent.new( timestamp )
              event.player = player

              db.new_player( event )
            else
              @temp_players[player_seqnum] = player
            end
            
            @seqnums[player_seqnum] = player.id
          when :G # Game? (name changes are included here)
            case entry[2].to_sym
            when :NameChange
              player_seqnum = entry[3].to_i
              player_id = @seqnums[player_seqnum]
              
              event = PlayerNameChangeEvent.new( timestamp )
              event.player_id = player_id
              event.new_name = entry[4]
              
              db.player_name_change( event )
            end
          when :SG # ?
          when :PS # Player String?
            player_seqnum = entry[2].to_i
            address = entry[3]
            netspeed = entry[4]
            player_uid = entry[5]
            
            player = @temp_players[player_seqnum]
            
            player.uid = player_uid
            player.bot = false

            event = NewPlayerEvent.new( timestamp )
            event.player = player
            
            db.new_player( event )
            @temp_players.delete( player_seqnum )
          when :BI # ?
          when :P # Something with multikills and first bloods (also combo rewards)
            player_seqnum = entry[2].to_i

            event = SpecialKillEvent.new( timestamp )
            event.player_id = @seqnums[player_seqnum]
            event.type = entry[3]

            db.special_kill( event )
          when :K # Kill
            killer_seqnum = entry[2].to_i
            victim_seqnum = entry[4].to_i
            
            event = KillEvent.new( timestamp )
            event.killer_id = @seqnums[killer_seqnum]
            event.victim_id = @seqnums[victim_seqnum]
            event.dmgtype = entry[3]
            event.weapon = entry[5]

            db.kill( event )
          when :PP # ?
          when :EG # End Game
            event = EndGameEvent.new( timestamp )
            event.reason = entry[2]

            db.end_game( event )
          end
        end
      end
    end
  end
end

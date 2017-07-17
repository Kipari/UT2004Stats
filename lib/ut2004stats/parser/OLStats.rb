require 'date' # for interpreting timestamps
require_relative '../game'

module UT2004Stats
  module Parser
    class OLStats
      def initialize
        clear_match_state
      end

      def clear_match_state
        @match = nil
        @seqnums = {}
        @temp_players = {}
      end
      
      def parse ( log )
        # gsub converts DOS-style line breaks to Unix-style line breaks
        log.gsub(/\r/,"").split("\n").each do |line|
          entry = line.split("\t")
          next unless entry.length > 1
          timestamp = entry[0].to_f
          case entry[1].to_sym
          when :S # Score
            unless @match then next end
            player_seqnum = entry[2].to_i

            match_id = @match.id
            player_id = @seqnums[player_seqnum].p_id
            score = entry[3].to_f
            reason = entry[4]

            score_entry = Score.find_or_create_by(match_id: match_id, player_id: player_id)
            score_entry.increment!(:score, score)
          when :NG # New Game
            if @match
              @match.save
              clear_match_state
            end
            
            start_time = DateTime.parse( entry[2] )
            map_id = entry[4]
            map_name = entry[5]
            map_creator = entry[6]
            gamemode = entry[7]
            gameparams = entry[8]

            @match = Match.create(start_time: start_time,
                                  map_id: map_id,
                                  gamemode: gamemode,
                                  gameparams: gameparams)
          when :SI # Server Initialization
            server_name = entry[2]
            params = entry[7]
          when :C # Connect (player)
            player_seqnum = entry[2].to_i
            uid = entry[3]
            p_id = entry[4]
            cdkey = entry[5]
            player = nil

            # If a player has no CD-key, he must be a bot
            unless cdkey
              player = Player.find_or_create_by(p_id: uid)
              player.name = "[BOT] #{uid}"
              player.bot = true
            else
              player = Player.find_or_create_by(p_id: p_id)
              player.cdkey = cdkey
              @temp_players[player_seqnum] = player
            end
            
            player.uid = uid

            player.save

            @seqnums[player_seqnum] = player
          when :G # Game? (name changes are included here)
            case entry[2].to_sym
            when :NameChange
              player_seqnum = entry[3].to_i
              if player_seqnum == -1 then next end
              new_name = entry[4]
              
              player = @seqnums[player_seqnum]
              player.update(name: new_name)
            end
          when :SG # ?
          when :PS # Player String?
            player_seqnum = entry[2].to_i
            address = entry[3]
            netspeed = entry[4]
            player_other_string = entry[5]
            player = @temp_players[player_seqnum]
            player.update(other_string: player_other_string, bot: false)
            @temp_players.delete( player_seqnum )
          when :BI # ?
          when :P # Something with multikills and first bloods (also combo rewards)
            player_seqnum = entry[2].to_i

            player = @seqnums[player_seqnum]
            type = entry[3]
            SpecKill.create(match_id: @match.id,
                            timestamp_match: timestamp,
                            player_id: player.p_id,
                            spectype: type)
          when :K # Kill
            unless @match then next end
            killer_seqnum = entry[2].to_i
            victim_seqnum = entry[4].to_i

            victim = @seqnums[victim_seqnum]
            unless killer_seqnum == -1
              killer = @seqnums[killer_seqnum]
            else
              killer = victim
            end
            
            dmgtype = entry[3]
            weapon = entry[5]           
            
            Kill.create(match_id: @match.id,
                         timestamp_match: timestamp,
                         killer_id: killer.p_id,
                         victim_id: victim.p_id,
                         dmgtype: dmgtype,
                         weapon: weapon)
          when :PP # ?
          when :EG # End Game
            reason = entry[2]
            clear_match_state
          end
        end
      end
    end
  end
end

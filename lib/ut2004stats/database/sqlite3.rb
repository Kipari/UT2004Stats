require 'sqlite3'

require_relative '../game'

module UT2004Stats
  module Database
    class SQLite3
      
      def initialize(db_file)
        clear_match_state()
        @db = ::SQLite3::Database.new "tmp/test.db"
      end

      def clear_match_state
        @current_match = nil
      end

      ## Aggregating accessor methods

      def scores
        
      end

      def kills
        
      end

      def special_kills
        
      end

      
      ## Parser-called methods

      def score ( event )
        @db.execute("UPDATE Scores SET score = score + ? WHERE player_id = ?",
                   event.score, event.player_id)
      end
      
      def new_game ( event )
        @db.execute("INSERT INTO Matches (id, start_time, map_id, gamemode, params) VALUES (NULL,?,?,?,?)",
                   event.start_time.to_s, event.map, event.gamemode, event.params)

        # TODO Find better solution
        @current_match = @db.execute( "SELECT id FROM Matches WHERE start_time = ? AND map_id = ? AND gamemode = ? AND params = ?",
                                     event.start_time.to_s, event.map, event.gamemode, event.params)[0][0]
      end

      def end_game ( event )
        clear_match_state()
      end
      
      def server_init ( event )
      end
      
      def player_name_change ( event )
        @db.execute("UPDATE Players SET p_name = ? WHERE id = ?",
                   event.new_name, event.player_id)
      end

      def special_kill ( event )
        @db.execute("INSERT INTO SpecKills (match_id, match_time, player_id, kill_type) VALUES (?, ?, ?, ?)",
                   @current_match, nil, event.player_id, event.type)
      end

      def kill ( event )
        @db.execute("INSERT INTO Kills (match_id, match_time, killer_id, victim_id, weapon, dmgtype) VALUES (?, ?, ?, ?, ?, ?)",
                   @current_match, nil, event.killer_id, event.victim_id, event.weapon, event.dmgtype)
      end

      def new_player ( event )
        player = event.player
        
        # Check if player already exists       
        unless @db.execute("SELECT id FROM Players WHERE id = ?", player.id)[0]
          @db.execute("INSERT INTO Players (id, uid, p_name, cdkey, bot) VALUES (?, ?, ?, ?, ?)",
                     player.id, player.uid, player.name, player.cdkey, player.bot ? 1 : 0)
          @db.execute("INSERT INTO Scores (player_id, match_id, score) VALUES (?, ?, 0)",
                     player.id, @current_match)
        end
      end
      
      attr_accessor :players, :matches
    end
  end
end

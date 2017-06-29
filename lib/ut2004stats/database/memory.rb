require_relative '../game'

module UT2004Stats
  module Database
    class Memory

      def initialize
        @scores = {}
        @kills = []
        @special_kills = []
        @players = {}
      end
      
      def score ( event )
        # Initialize score if not set
        player = @players[event.player_id]
        unless @scores[player]
          @scores[player] = 0
        end
        
        @scores[player] += event.score
      end
      
      def new_game ( event )
        match = Match.new
        match.start_time = event.start_time
        match.map = event.map
        match.gamemode = event.gamemode

        @current_match = match
      end

      def end_game ( event )
        if @current_match then
          @matches << @current_match
          @current_match = nil
        end
      end
      
      def server_init ( event )
      end
      
      def player_name_change ( event )
        @players[event.player_id].name = event.new_name
      end

      def special_kill ( event)
        @special_kills << event
      end

      def kill ( event )
        kill = Kill.new
        kill.killer_id = event.killer_id
        kill.victim_id = event.victim_id
        kill.weapon = event.weapon
        kill.dmgtype = event.dmgtype
        @kills << kill
      end

      def new_player ( event )
        player = event.player
        # Check if player already exists
        unless @players[player.id]
          @players[player.id] = player
        end
      end
      
      attr_accessor :scores, :kills, :players, :special_kills
    end
  end
end

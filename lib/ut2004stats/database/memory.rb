require_relative '../game'

module UT2004Stats
  module Database
    class Memory
      def initialize
        clear_match_state()
        @players = {}
        @matches = []
      end

      def clear_match_state
        @scores = Hash.new(0.0)
        @kills = []
        @special_kills = []
        @current_match = nil
      end

      ## Aggregating accessor methods

      def scores
        matches.inject(Hash.new(0)) do |memo, match|
          match.scores.each { |k,v| memo[k] += v }
          memo
        end
      end

      def kills
        matches.inject([]) { |memo, match| memo + match.kills }
      end

      def special_kills
        matches.inject([]) { |memo, match| memo + match.special_kills }
      end

      
      ## Parser-called methods

      def score ( event )
        # Initialize score if not set
        player = @players[event.player_id]
        
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
          match = @current_match
          match.scores = @scores.clone
          match.kills = @kills.clone
          match.special_kills = @special_kills.clone
          
          @matches << match
          
          clear_match_state()
        end
      end
      
      def server_init ( event )
      end
      
      def player_name_change ( event )
        @players[event.player_id].name = event.new_name
      end

      def special_kill ( event )
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

        @current_match.players << player.id
        
        # Check if player already exists
        unless @players[player.id]
          @players[player.id] = player
        end
      end
      
      attr_accessor :players, :matches
    end
  end
end

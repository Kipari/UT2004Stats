require_relative '../game'

module UT2004Stats
  module Database
    class Memory

      def initialize
        @scores = {}
        @seqnums = {}
        @names = {}
        @kills = []
        @special_kills = []
        @players = {}
      end
      
      def score ( event )
        # Initialize score if not set
        unless @scores[event.player_seqnum]
          @scores[event.player_seqnum] = 0
        end
        
        @scores[event.player_seqnum] += event.score
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
        @names[event.player_seqnum] = event.new_name
      end

      def special_kill ( event)
        @special_kills << event
      end

      def kill ( event )
        @kills << event
      end

      def player_connect ( event )
        player = Player.new
        player.name = event.player_name
        player.cdkey = event.cdkey
        player.other_string = event.other_string
       
        @seqnums[event.player_seqnum] = player
      end

      def player_string ( event )
        player = @seqnums[event.player_seqnum]
        player.uid = event.player_uid
        @players[player.uid] = player
      end
      
      attr_accessor :scores, :seqnums, :names, :kills, :players, :special_kills
    end
  end
end

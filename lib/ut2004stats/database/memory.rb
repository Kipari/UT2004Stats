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
        player = @players[@seqnums[event.player_seqnum].id]
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
        player = @seqnums[event.player_seqnum]
        @names[event.player_seqnum] = event.new_name
      end

      def special_kill ( event)
        @special_kills << event
      end

      def kill ( event )
        kill = Kill.new
        kill.killer = @seqnums[event.player_seqnum].id
        kill.victim = @seqnums[event.victim_seqnum].id
        kill.weapon = event.weapon
        kill.dmgtype = event.dmgtype
        @kills << kill
      end

      def player_connect ( event )
        player = Player.new
        player.name = event.player_name
        player.cdkey = event.cdkey
        player.id = event.other_string

        # If a player has no CD-key, he must be a bot
        unless player.cdkey
          player.name = "[BOT] #{player.id}"
          player.bot = true
          @players[player.id] = player
        end

        @seqnums[event.player_seqnum] = player
      end

      def player_string ( event )
        player = @seqnums[event.player_seqnum]
        player.uid = event.player_uid
        player.bot = false
        # Check if player already exists
        unless @players[player.id]
          @players[player.id] = player
        end
      end
      
      attr_accessor :scores, :seqnums, :names, :kills, :players, :special_kills
    end
  end
end

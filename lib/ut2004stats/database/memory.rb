module UT2004Stats
  module Database
    class Memory

      def initialize
        @scores = {}
        @seqnums = {}
        @names = {}
      end
      
      def score ( event )
        # Initialize score if not set
        unless @scores[event.player_seqnum]
          @scores[event.player_seqnum] = 0
        end
        
        @scores[event.player_seqnum] += event.score
      end
      
      def new_game ( event )
      end
      
      def server_init ( event )
      end
      
      def player_name_change ( event )
        @names[event.player_seqnum] = event.new_name
      end

      attr_accessor :scores, :seqnums, :names
    end
  end
end

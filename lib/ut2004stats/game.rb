module UT2004Stats
  class Match
    include Comparable

    def initialize
      @players = []
    end
    
    def <=> ( other )
      self.start_time <=> other.start_time
    end
    attr_accessor :start_time, :map, :gamemode, :players, :scores, :kills, :special_kills
  end

  class Player
    include Comparable
    def <=> ( other )
      self.name <=> other.name
    end
    
    def bot?
      @bot
    end

    attr_accessor :uid, :name, :cdkey, :id, :bot
  end

  class Kill
    attr_accessor :killer_id, :victim_id, :weapon, :dmgtype
  end
end

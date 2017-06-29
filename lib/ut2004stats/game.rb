module UT2004Stats
  class Match
    attr_accessor :start_time, :map, :gamemode, :players, :scores, :kills, :special_kills
  end

  class Player
    def bot?
      @bot
    end

    attr_accessor :uid, :name, :cdkey, :id, :bot
  end

  class Kill
    attr_accessor :killer_id, :victim_id, :weapon, :dmgtype
  end
end

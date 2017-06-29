module UT2004Stats
  class Match
    attr_accessor :start_time, :map, :gamemode, :players
  end

  class Player
    def bot?
      @bot
    end

    attr_accessor :uid, :name, :cdkey, :id, :bot
  end

  class Kill
    attr_accessor :killer, :victim, :weapon, :dmgtype
  end
end

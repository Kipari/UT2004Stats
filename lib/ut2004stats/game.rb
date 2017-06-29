module UT2004Stats
  class Match
    attr_accessor :start_time, :map, :gamemode, :players
  end

  class Player
    attr_accessor :uid, :name, :cdkey, :other_string
  end
end

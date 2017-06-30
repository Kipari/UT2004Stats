module UT2004Stats
  module LogEvent
    def initialize ( timestamp )
      @timestamp = timestamp
    end

    def ==(other)
      other.class == self.class && other.state == self.state
    end

    def state
      self.instance_variables.map { |variable| self.instance_variable_get variable }
    end
    
    attr_accessor :timestamp
  end
  
  class NewGameEvent
    include LogEvent
    attr_accessor :start_time, :map, :map_name, :map_creator, :gamemode, :params
  end

  class ServerInitEvent
    include LogEvent
    attr_accessor :server_name, :params
  end

  class PlayerNameChangeEvent
    include LogEvent
    attr_accessor :player_id, :new_name
  end

  class ScoreEvent
    include LogEvent
    attr_accessor :player_id, :score, :reason
  end

  class KillEvent
    include LogEvent
    attr_accessor :killer_id, :victim_id, :dmgtype, :weapon
  end

  class SpecialKillEvent
    include LogEvent
    attr_accessor :player_id, :type
  end

  class NewPlayerEvent
    include LogEvent
    attr_accessor :player
  end

  class EndGameEvent
    include LogEvent
    attr_accessor :reason
  end
end

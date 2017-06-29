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
    attr_accessor :start_time, :map_file, :map, :map_creator, :gamemode, :params
  end

  class ServerInitEvent
    include LogEvent
    attr_accessor :server_name, :params
  end

  class PlayerNameChangeEvent
    include LogEvent
    attr_accessor :player_seqnum, :new_name
  end

  class ScoreEvent
    include LogEvent
    attr_accessor :player_seqnum, :score, :reason
  end

  class KillEvent
    include LogEvent
    attr_accessor :player_seqnum, :victim_seqnum, :dmgtype, :weapon
  end

  class SpecialKillEvent
    include LogEvent
    attr_accessor :player_seqnum, :type
  end

  class PlayerConnectEvent
    include LogEvent
    attr_accessor :player_seqnum, :player_name, :cdkey, :other_string
  end

  class PlayerStringEvent
    include LogEvent
    attr_accessor :player_seqnum, :address, :netspeed, :player_uid
  end
end

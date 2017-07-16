require 'active_record'

module UT2004Stats
  class Match < ActiveRecord::Base
    has_many :players
    has_many :kills
    has_many :spec_kills
    has_many :scores
    
    include Comparable
    
    def <=> ( other )
      self.start_time <=> other.start_time
    end
  end

  class Player < ActiveRecord::Base
    self.primary_key = 'p_id'
    
    has_many :kills, :class_name => 'Kill', :foreign_key => 'killer_id'
    has_many :deaths, :class_name => 'Kill', :foreign_key => 'victim_id'
    has_many :spec_kills
    has_many :scores
    
    include Comparable
    def <=> ( other )
      self.name <=> other.name
    end
    
    def bot?
      @bot
    end
  end

  class Kill < ActiveRecord::Base
    belongs_to :match
    belongs_to :killer, :class_name => 'Player', :foreign_key => 'killer_id'
    belongs_to :victim, :class_name => 'Player'
  end

  class Score < ActiveRecord::Base
    belongs_to :match
    belongs_to :player
  end

  class SpecKill < ActiveRecord::Base
    belongs_to :match
    belongs_to :player
  end
end

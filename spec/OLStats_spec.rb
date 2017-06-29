$:.unshift File.dirname("#{__FILE__}/lib")
require 'ut2004stats/parser/OLStats'
require 'ut2004stats/events'

describe  UT2004Stats::Parser::OLStats do
  let(:parser) { UT2004Stats::Parser::OLStats.new }
  
  
  describe '.parse' do
    context "given a score string" do
      it "passes the expected ScoreEvent to the database" do
        db = spy("db")
        parser.parse("51.08\tS\t3\t1.00\tfrag", db)
        expected_event = UT2004Stats::ScoreEvent.new(51.08)
        expected_event.score = 1.00
        expected_event.player_seqnum = 3
        expected_event.reason = "frag"

        expect(db).to have_received(:score).with(expected_event)
      end
    end

    context "given a kill string" do
      it "passes the expected KillEvent to the database" do
        db = spy("db")
        parser.parse("19.58\tK\t4\tDamTypeSuperShockBeam\t51\tSuperShockRifle", db)
        expected_event = UT2004Stats::KillEvent.new(19.58)
        expected_event.player_seqnum = 4
        expected_event.damage_type = "DamTypeSuperShockBeam"
        expected_event.victim_seqnum = 51
        expected_event.weapon = "SuperShockRifle"

        expect(db).to have_received(:kill).with(expected_event)
      end
    end
  end
end

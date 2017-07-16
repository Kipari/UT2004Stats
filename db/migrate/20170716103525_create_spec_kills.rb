class CreateSpecKills < ActiveRecord::Migration[5.1]
  def change
    create_table :spec_kills do |t|
      t.integer :match_id
      t.decimal :timestamp_match
      t.string :player_id
      t.string :spectype
    end
  end
end

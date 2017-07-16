class CreateKills < ActiveRecord::Migration[5.1]
  def change
    create_table :kills do |t|
      t.integer :match_id
      t.decimal :timestamp_match
      t.string :killer_id
      t.string :victim_id
      t.string :weapon
      t.string :dmgtype
    end
  end
end

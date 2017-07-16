class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.integer :match_id
      t.string :player_id
      t.decimal :score
    end
  end
end

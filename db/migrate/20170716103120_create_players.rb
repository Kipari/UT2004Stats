class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :p_id
      t.string :uid
      t.string :other_string
      t.string :name
      t.string :cdkey
      t.boolean :bot
    end
  end

  def self.down
    drop_table :players
  end
end

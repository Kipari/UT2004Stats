class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.timestamp :start_time
      t.string :map_id
      t.string :gamemode
      t.string :gameparams
    end
  end
end

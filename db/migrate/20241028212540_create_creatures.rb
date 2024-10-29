class CreateCreatures < ActiveRecord::Migration[7.1]
  def change
    create_table :creatures do |t|
      t.string :name
      t.integer :initiative_modifier
      t.string :portrait
      t.integer :fodder_id

      t.timestamps
    end
  end
end

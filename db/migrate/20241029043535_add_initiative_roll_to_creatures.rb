class AddInitiativeRollToCreatures < ActiveRecord::Migration[7.1]
  def change
    add_column :creatures, :initiative_roll, :integer
  end
end

class Creature < ApplicationRecord
  def self.add_fodder(name, initiative_modifier, quantity, portrait = nil)
    fodder_id = Creature.maximum(:fodder_id).to_i + 1
    quantity.times do |i|
      Creature.create(
        name: "#{name} #{i + 1}",
        initiative_modifier: initiative_modifier,
        portrait: portrait,
        fodder_id: fodder_id
      )
    end
  end

  def roll_initiative
    self.initiative_roll = rand(1..20) + initiative_modifier
    save
  end

  def self.roll_all_initiatives
    all.each(&:roll_initiative)
  end
end

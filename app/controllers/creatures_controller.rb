class CreaturesController < ApplicationController

  require 'csv'

  def index
    @creatures = Creature.order(initiative_roll: :desc)
    @current_turn_index = 0
  end

  def roll_initiatives
    Creature.roll_all_initiatives
    redirect_to creatures_path, notice: 'Initiative rolled for all creatures.'
  end

  def create
    encounter = Encounter.find_by(id: params[:encounter_id])

    # Check if adding multiple creatures or just one
    if params[:quantity].to_i > 1
      # Adding fodder
      Creature.add_fodder(
        params[:name],
        params[:initiative_modifier],
        params[:quantity].to_i,
        params[:portrait],
        encounter_id: encounter&.id
      )
    else
      # Adding a single creature
      Creature.create(
        name: params[:name],
        initiative_modifier: params[:initiative_modifier],
        portrait: params[:portrait],
        encounter_id: encounter&.id
      )
    end

    # Redirect back to the encounter's page if an encounter ID is present
    if encounter
      redirect_to encounter_path(encounter), notice: 'Creature(s) added to encounter.'
    else
      redirect_to creatures_path, notice: 'Creature(s) added.'
    end
  end

  def clear_encounters
    Creature.delete_all  # This will remove all creatures from the database
    redirect_to creatures_path, notice: 'All encounters have been cleared.'
  end

  def export_encounter
    # Convert creatures to JSON
    creatures = Creature.all
    respond_to do |format|
      format.json { render json: creatures }
      format.csv { send_data to_csv(creatures), filename: "encounter_#{Date.today}.csv" }
      format.html { send_data to_csv(creatures), filename: "encounter_#{Date.today}.csv" } # Optional: Default to CSV for HTML
    end
  end

  def import_encounter
    if params[:file].present?
      file = params[:file].tempfile
      data = CSV.read(file, headers: true)

      data.each do |row|
        Creature.create(
          name: row['name'],
          initiative_modifier: row['initiative_modifier'],
          portrait: row['portrait']
        )
      end

      redirect_to creatures_path, notice: 'Encounters imported successfully.'
    else
      redirect_to creatures_path, alert: 'Please upload a valid file.'
    end
  end

  private

  def to_csv(creatures)
    CSV.generate(headers: true) do |csv|
      csv << ['name', 'initiative_modifier', 'portrait']
      creatures.each do |creature|
        csv << [creature.name, creature.initiative_modifier, creature.portrait]
      end
    end
  end
end

class CreateDestinyEnergyTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :destiny_energy_types do |t|
      Destiny::Migration.add_common_fields(t)
    end
  end
end

class ChangeTripCostType < ActiveRecord::Migration[6.0]
  def change
    change_column :trips, :cost, :float
  end
end

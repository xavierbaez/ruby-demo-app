class AddVolumeToMetrics < ActiveRecord::Migration[8.1]
  def change
    add_column :metrics, :volume, :decimal
  end
end

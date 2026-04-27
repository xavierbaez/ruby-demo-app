class CreateMetrics < ActiveRecord::Migration[8.1]
  def change
    create_table :metrics do |t|
      t.string :service_name
      t.string :metric_name
      t.decimal :value
      t.date :recorded_on

      t.timestamps
    end
  end
end

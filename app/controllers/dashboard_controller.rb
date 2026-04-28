class DashboardController < ApplicationController
  def index
    @chart_data = Metric
                    .order(:recorded_on)
                    .group_by(&:service_name)
                    .transform_values { |records| records.map { |r| [r.recorded_on, r.value.to_f] } }
  end
end

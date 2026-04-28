class DashboardController < ApplicationController
  def index
    @chart_data = Metric
                    .where(service_name: "Apple Market Signal")
                    .order(:recorded_on)
                    .map { |m| [m.recorded_on, m.value.to_f] }

    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    @latest_metrics = Metric
                        .where(service_name: "Apple Market Signal")
                        .order(recorded_on: :desc)
                        .limit(10)
                        .to_a

    @query_time = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round(2)
  end
end

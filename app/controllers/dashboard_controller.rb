class DashboardController < ApplicationController
  def index
    metrics = Metric.where(service_name: "Apple Market Signal").order(:recorded_on)

    # Line chart - daily close price
    @chart_data = metrics.map { |m| [m.recorded_on, m.value.to_f] }

    # Bar chart - monthly average close
    @monthly_avg = metrics.group_by { |m| m.recorded_on.strftime("%b %Y") }
                          .transform_values { |records| (records.sum(&:value) / records.size).round(2) }

    # Pie chart - volume last 30 days vs previous 30 days
    today = Date.today
    last_30 = metrics.select { |m| m.recorded_on >= today - 30 }
    prev_30 = metrics.select { |m| m.recorded_on >= today - 60 && m.recorded_on < today - 30 }

    @volume_data = {
      "Last 30 Days" => last_30.sum(&:volume).to_i,
      "Previous 30 Days" => prev_30.sum(&:volume).to_i
    }

    # Stat cards
    @high = metrics.maximum(:value).to_f.round(2)
    @low = metrics.minimum(:value).to_f.round(2)
    @avg = (metrics.sum(:value) / metrics.count).to_f.round(2)

    # Query time
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Metric.where(service_name: "Apple Market Signal").order(recorded_on: :desc).limit(10).to_a
    @query_time = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round(2)
  end
end
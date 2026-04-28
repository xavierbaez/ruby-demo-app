class DashboardController < ApplicationController
  def index
    metrics = Metric.where(service_name: "Apple Market Signal").order(:recorded_on)

    values = metrics.map { |m| m.value.to_f }
    min_val = values.min
    max_val = values.max
    range = max_val - min_val
    dates = metrics.map(&:recorded_on)

    # Each service normalized independently to its own realistic range
    @icloud_trend = dates.zip(values.map { |v|
      ((900 + ((v - min_val) / range) * 50).round(1))
    }).to_h

    @music_trend = dates.zip(values.map { |v|
      ((100 + ((v - min_val) / range) * 8).round(1))
    }).to_h

    @tvplus_trend = dates.zip(values.map { |v|
      ((45 + ((v - min_val) / range) * 5).round(1))
    }).to_h

    @arcade_trend = dates.zip(values.map { |v|
      ((20 + ((v - min_val) / range) * 2).round(1))
    }).to_h

    # Pie chart - current subscriber share
    @subscriber_share = {
      "iCloud"       => 900,
      "Apple Music"  => 100,
      "Apple TV+"    => 45,
      "Apple Arcade" => 20
    }

    # Bar chart - month over month growth %
    @monthly_growth = {
      "iCloud"       => 2.1,
      "Apple Music"  => 3.4,
      "Apple TV+"    => 8.7,
      "Apple Arcade" => 5.2
    }

    # Stat cards
    @total_subscribers = "1.065B"
    @fastest_growing   = "Apple TV+"
    @yoy_growth        = "13.5%"

    # Query performance
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    Metric.where(service_name: "Apple Market Signal").order(recorded_on: :desc).limit(10).to_a
    @query_time = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round(2)
  end
end
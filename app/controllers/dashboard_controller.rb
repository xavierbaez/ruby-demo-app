class DashboardController < ApplicationController
  def index
    metrics = Metric.where(service_name: "Apple Market Signal").order(:recorded_on)

    # Base multipliers to simulate realistic subscriber counts per service
    icloud_base    = 900_000_000
    music_base     = 100_000_000
    tvplus_base    = 45_000_000
    arcade_base    = 20_000_000

    # Normalize AAPL close prices to a 0-1 scale to drive subscriber fluctuation
    values = metrics.map { |m| m.value.to_f }
    min_val = values.min
    max_val = values.max
    range = max_val - min_val

    normalized = metrics.map do |m|
      [(m.value.to_f - min_val) / range]
    end

    dates = metrics.map(&:recorded_on)

    # Build multi-series line chart data
    @subscriber_trend = {
      "iCloud"        => dates.zip(normalized.map { |n| (icloud_base + n[0] * 50_000_000).round }).to_h,
      "Apple Music"   => dates.zip(normalized.map { |n| (music_base + n[0] * 8_000_000).round }).to_h,
      "Apple TV+"     => dates.zip(normalized.map { |n| (tvplus_base + n[0] * 5_000_000).round }).to_h,
      "Apple Arcade"  => dates.zip(normalized.map { |n| (arcade_base + n[0] * 2_000_000).round }).to_h
    }

    # Pie chart - current subscriber share
    @subscriber_share = {
      "iCloud"       => 900_000_000,
      "Apple Music"  => 100_000_000,
      "Apple TV+"    => 45_000_000,
      "Apple Arcade" => 20_000_000
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
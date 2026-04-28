namespace :alphavantage do
  desc "Import AAPL daily stock data into metrics"
  task import_aapl: :environment do
    require "net/http"
    require "json"

    api_key = ENV["ALPHAVANTAGE_API_KEY"] || Rails.application.credentials.dig(:alphavantage, :api_key)

    if api_key.blank?
      puts "Missing AlphaVantage API key"
      exit
    end

    url = URI("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=AAPL&outputsize=compact&apikey=#{api_key}")

    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    time_series = data["Time Series (Daily)"]

    if time_series.blank?
      puts "No time series found."
      puts data.inspect
      exit
    end

    Metric.where(service_name: "Apple Market Signal").delete_all

    time_series.each do |date, values|
      Metric.create!(
        service_name: "Apple Market Signal",
        metric_name: "daily_close",
        value: values["4. close"].to_f,
        volume: values["5. volume"].to_f,
        recorded_on: Date.parse(date)
      )
    end

    puts "Imported #{time_series.count} AAPL records."
  end
end
class Weather < ActiveRecord::Base
  validates :description, :temperature, :speed, :data, :lat, :lon, presence: true

  TIME_RANGE = 15.minutes
  LOCATION_PRECISION = 2

  def self.current_weather location
    location = optimize_location(location)

    if (report = latest_weather(location))
      report
    else
      update_weather_for(location)
    end
  end

  def self.update_weather_for(location)
    data = OpenWeatherApi.get_weather(location)
    content = {}
    content[:description] = data['weather'].first['description'] if data['weather'].first['description']
    content[:temperature] = data['main']['temp'].to_f if data['main']['temp']
    content[:speed] = data['wind']['speed'].to_f if data['wind']['speed']
    content[:data] = data
    content[:lat] = location['lat']
    content[:lon] = location['lon']

    Weather.create!(content)
  end

  def self.latest_weather location
    where(lat: location['lat'], lon: location['lon'], created_at: (TIME_RANGE.ago)..Time.now).first
  end

  def self.optimize_location location
    location['lat'] = location['lat'].to_f.round(LOCATION_PRECISION) if location['lat']
    location['lon'] = location['lon'].to_f.round(LOCATION_PRECISION) if location['lon']
    location
  end

  def as_json(options = {})
    super(:only => [:description, :temperature, :speed])
  end
end

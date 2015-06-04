require 'open-uri'
require 'net/https'
require 'json'

class OpenWeatherApi
  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.2 Safari/537.36'

  def self.page_content(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    url = URI.parse(uri_str)
    puts url

    http = Net::HTTP.new(url.host, url.port)
    if url.is_a? URI::HTTPS
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    req = Net::HTTP::Get.new(url.path, {
      'User-Agent' => USER_AGENT
    })

    response = http.request(req)
    # puts response.body

    case response
    when Net::HTTPSuccess     then response.body
    when Net::HTTPRedirection then page_content(response['location'], limit - 1)
    else
      response.error!
    end
  end

  def self.open_json url
    JSON.load(open(url))
  end

  def self.get_weather location
    url = "http://api.openweathermap.org/data/2.5/weather?lat=#{location['lat']}&lon=#{location['lon']}"
    open_json url
  end

end

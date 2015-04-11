require 'net/http'
require 'uri'
require 'json'

class GoogleGeoApi

  def self.request(latlng)
    webapi(
      'http://maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        latlng: latlng,
        sensor: 'false',
        language: 'ja'
      }
    )
  end

  def self.webapi(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    uri = URI.parse("#{site}#{path}?#{params}")

    https = Net::HTTP.new(uri.host, uri.port)
    res = https.start {
      https.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

end

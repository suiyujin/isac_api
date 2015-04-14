require File.dirname(__FILE__) + '/web_api'

class GoogleGeoApi < WebApi
  def self.request(latlng)
    super(
      'http://maps.googleapis.com',
      '/maps/api/geocode/json',
      {
        latlng: latlng,
        sensor: 'false',
        language: 'ja'
      }
    )
  end
end

require 'net/https'
require 'uri'
require 'json'

class FlickrApi

  def self.request(lat, lng)
    webapi(
      'https://api.flickr.com',
      '/services/rest/',
      {
        method: 'flickr.photos.search',
        api_key: '2cd9686803e79250ec18f0059c0cff79',
        text: 'globalwarming',
        lat: lat,
        lon: lng,
        radius: '32',
        extras: 'description%2Cdate_upload%2C+tags%2Curl_o',
        per_page: '8',
        format: 'json',
        nojsoncallback: '1'
      }
    )
  end

  def self.webapi(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    uri = URI.parse("#{site}#{path}?#{params}")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = https.start {
      https.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

end


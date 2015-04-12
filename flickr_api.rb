require 'net/https'
require 'uri'
require 'json'
require 'addressable/uri'
require 'csv'

class FlickrApi

  def self.request(lat, lng)
    webapi(
      'https://api.flickr.com',
      '/services/rest/',
      {
        method: 'flickr.photos.search',
        api_key: '2cd9686803e79250ec18f0059c0cff79',
        text: make_query,
        bbox: "#{lng.to_f - 3.0},#{lat.to_f - 3.0},#{lng.to_f + 3.0},#{lat.to_f + 3.0}",
        extras: 'description,date_upload,tags,url_o',
        per_page: '8',
        format: 'json',
        nojsoncallback: '1'
      }
    )
  end

  def self.make_query
    words = ''
    CSV.foreach("#{File.dirname(__FILE__)}/words_en.csv", 'r') do |row|
      words = row.join(' OR ').gsub(/\s/, '%20')
    end
    words
  end

  def self.webapi(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    uri = Addressable::URI.parse("#{site}#{path}?#{params}")

    https = Net::HTTP.new(uri.host, '443')
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    res = https.start {
      https.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

end


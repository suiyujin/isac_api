require 'net/http'
require 'uri'
require 'json'
require 'addressable/uri'
require 'csv'

class GoogleNewsApi

  def self.request(address)
    webapi(
      'http://ajax.googleapis.com',
      '/ajax/services/search/news',
      {
        v: '1.0',
        hl: 'ja',
        ned: 'jp',
        rsz: '8',
        q: make_query(address)
      }
    )
  end

  def self.make_query(address)
    words = ''
    CSV.foreach("#{File.dirname(__FILE__)}/words.csv", 'r') do |row|
      words = row.join(' OR ')
    end
    "#{address} AND (#{words})"
  end

  def self.webapi(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    p "#{site}#{path}#{params}"
    uri = Addressable::URI.parse(URI.escape("#{site}#{path}?#{params}"))

    https = Net::HTTP.new(uri.host, uri.port)
    res = https.start {
      https.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

end

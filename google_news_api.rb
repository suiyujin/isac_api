require 'net/http'
require 'uri'
require 'json'
require 'addressable/uri'

class GoogleNewsApi

  def self.request(address)
    webapi(
      'http://ajax.googleapis.com',
      '/ajax/services/search/news',
      {
        v: '1.0',
        hl: 'ja',
        rsz: '8',
        q: "環境問題 #{address}"
      }
    )
  end

  def self.make_query(address)

  end

  def self.webapi(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    uri = Addressable::URI.parse(URI.escape("#{site}#{path}?#{params}"))
    p uri

    https = Net::HTTP.new(uri.host, uri.port)
    res = https.start {
      https.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

end

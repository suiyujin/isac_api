require 'json'
require 'addressable/uri'

class WebApi
  def self.request(site, path, hash_params)
    params = hash_params.map { |key, value| "#{key}=#{value}" }.join('&')
    uri = Addressable::URI.parse(URI.escape("#{site}#{path}?#{params}"))

    http = Net::HTTP.new(uri.host, uri.port)
    res = http.start {
      http.get(uri.request_uri)
    }

    JSON.parse(res.body)
  end

  def self.request_ssl(site, path, hash_params)
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

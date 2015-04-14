require 'csv'
require File.dirname(__FILE__) + '/web_api'

class FlickrApi < WebApi
  def self.request_ssl(lat, lng)
    super(
      'https://api.flickr.com',
      '/services/rest/',
      {
        method: 'flickr.photos.search',
        api_key: ENV['FLICKR_API_KEY'],
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
end

require 'sinatra'
require 'json'
require 'date'
require File.dirname(__FILE__) + '/google_geo_api'
require File.dirname(__FILE__) + '/google_news_api'
require File.dirname(__FILE__) + '/flickr_api'
require 'newrelic_rpm'

class App < Sinatra::Base
  before do
    content_type 'application/json', :charset => 'utf-8'
  end

  get '/' do
    # apiがoffの場合はAPIにリクエストしない
    return {message: 'API OFF'}.to_json if params['api'] == 'off'

    latlng = "#{params['lat']},#{params['lng']}"
    response = GoogleGeoApi.request(latlng)
    array_addresses = response['results'][0]['address_components'].map do |component|
      {
        long_name: component['long_name'],
        type: component['types'][0]
      }
    end
    # TODO countryだけでなく地域も調べる
    address_index = array_addresses.find_index { |address| address[:type] == 'country' }
    normalize_articles(GoogleNewsApi.request(array_addresses[address_index][:long_name]))
  end

  get '/flickr' do
    # apiがoffの場合はAPIにリクエストしない
    return {message: 'API OFF'}.to_json if params['api'] == 'off'

    normalize_photos(FlickrApi.request(params['lat'], params['lng']))
  end

  def normalize_articles(row_articles)
    {
      results: row_articles['responseData']['results'].map do |result|
        normalized_articles = {
          title: result['titleNoFormatting'],
          content: result['content'],
          url: result['unescapedUrl'],
          publishedDate: Date.strptime(result['publishedDate'], "%a, %d %b %Y %H:%M:%S").strftime("%Y.%b.%d"),
          publisher: result['publisher']
        }
        normalized_articles.store(:imageUrl, result['image']['url']) if result['image']
        normalized_articles
      end
    }.to_json
  end

  def normalize_photos(row_photos)
    local_timezone = ENV['TZ']
    ENV['TZ'] = 'UTC'
    date_upload = Time.at(1428699964).strftime("%Y.%b.%d")
    ENV['TZ'] = local_timezone

    normalized_photos = {
      results: row_photos['photos']['photo'].map do |result|
        {
          title: result['title'],
          content: result['description']['_content'],
          UploadedDate: date_upload,
          tags: result['tags'],
          imageUrl: result['url_o']
        }
      end
    }

    normalized_photos[:results].delete_if { |result| !result[:imageUrl] }
    normalized_photos.to_json
  end
end

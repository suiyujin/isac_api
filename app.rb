require 'sinatra'
require 'json'
require File.dirname(__FILE__) + '/google_geo_api'
require File.dirname(__FILE__) + '/google_news_api'

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

  def normalize_articles(row_article)
    {
      results: row_article['responseData']['results'].map do |result|
        normalized_list = {
          title: result['titleNoFormatting'],
          content: result['content'],
          url: result['unescapedUrl'],
          publishedDate: result['publishedDate'],
          publisher: result['publisher'],
        }
        normalized_list.store(:imageUrl, result['image']['url']) if result['image']
        normalized_list
      end
    }.to_json
  end
end

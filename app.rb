require 'sinatra'
require 'json'
require File.dirname(__FILE__) + '/google_geo_api'
require File.dirname(__FILE__) + '/google_news_api'

class App < Sinatra::Base
  before do
    content_type 'application/json', :charset => 'utf-8'
  end

  get '/' do
    # api-offがtrueの場合はAPIにリクエストしない
    return {message: 'API OFF'}.to_json if params['api'] == 'off'

    latlng = "#{params['lat']},#{params['lng']}"
    response = GoogleGeoApi.request(latlng)
    array_addresses = response['results'][0]['address_components'].map do |component|
      {
        long_name: component['long_name'],
        type: component['types'][0]
      }
    end
    p array_addresses[0][:type]
    address_index = array_addresses.find_index { |address| address[:type] == 'country' }
    GoogleNewsApi.request(array_addresses[address_index][:long_name]).to_json
  end
end

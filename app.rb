require 'sinatra'
require 'json'
require File.dirname(__FILE__) + '/google_geo_api'

before do
  content_type 'application/json'
end

get '/' do
  latlng = "#{params['lat']},#{params['lng']}"
  GoogleGeoApi.request(latlng)
end

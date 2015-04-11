require 'sinatra'
require 'json'

get '/' do
  v = {
        lat: params["lat"],
        lng: params["lng"]
  }

  v.to_json
end

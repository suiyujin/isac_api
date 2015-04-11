require 'sinatra'
require 'json'

get '/hello' do
  v = {
        key1: "a" ,
        key2: "b",
  }

  v.to_json
end

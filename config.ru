require 'rubygems'
require 'sinatra'

set :environment, :production
disable :run, :reload

$:.unshift(File.dirname(__FILE__))

require "app"

run Sinatra::Application

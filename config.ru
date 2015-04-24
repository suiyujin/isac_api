require 'rubygems'
require 'sinatra'

Encoding.default_external = 'UTF-8'

set :environment, :production
disable :run, :reload

$:.unshift(File.dirname(__FILE__))

require "app"

run App

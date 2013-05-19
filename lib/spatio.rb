require './config/initializers/geocoder'
require 'rgeo'
require 'sinatra'
require 'sinatra/activerecord'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'spatio/parser'
require 'spatio/reader'
require 'spatio/geocode'


ENV['RACK_ENV'] ||= 'development'

def conf(file)
  YAML.load_file('config/' + file).fetch(settings.environment.to_s)
end

module Spatio
  GEOFACTORY = ::RGeo::Geographic.simple_mercator_factory.projection_factory
end

ActiveRecord::Base.establish_connection conf('database.yml')
require 'models'

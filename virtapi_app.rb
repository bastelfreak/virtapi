# "This will automatically discover your Gemfile, and make all of the gems in
# your Gemfile available to Ruby." http://bundler.io/rationale.html
require 'bundler/setup'

require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/logger'
require 'sinatra/config_file'
require 'tilt/haml'
require 'json'
require 'active_record'

# preload node model because of Dir.glob order fuckup
# TODO: define a hierarchy of models to load

require_relative 'models/node.rb'
Dir.glob('./{lib,models,controllers}/*.rb').each { |file| require file }

@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection @dbconfig[@environment]

# manual style
# ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{__dir__}/dbfile.sqlite")

# load a config file (provided by sinatra-contrib)
# http://www.sinatrarb.com/contrib/config_file.html
config_file 'config/appconfig.yml'

# match request type, we do json encoding with the request ends with .json
# we do html otherwise
before /.*/ do # rubocop:disable Lint/AmbiguousRegexpLiteral
  if /.json$/ =~ request.path_info
    content_type :json, 'charset' => 'utf-8'
    request.accept.unshift('application/json')
    request.path_info = request.path_info.gsub(/.json$/, '')
  else
    content_type :html, 'charset' => 'utf-8'
  end
end

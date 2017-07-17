require 'yaml'
require 'active_record'

require_relative 'ut2004stats/game'

@environment = ENV['RACK_ENV'] || 'development'
@dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection @dbconfig[@environment]

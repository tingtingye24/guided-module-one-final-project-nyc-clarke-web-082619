require 'bundler'
require 'rubygems'
require 'tty-prompt'

Bundler.require
#require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'


# desc 'drop into the Pry console'
# task :console => :environment do
#   Pry.start
# end
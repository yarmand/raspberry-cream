require 'rubygems'
require 'bundler'

Bundler.require

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

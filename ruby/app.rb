require 'rubygems'
require 'bundler'
require 'yaml'

$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/lib"))
require 'yammer_poller'
require 'scheduler'
Bundler.require

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
  key_config = YAML::load_file('config/keys.yml')
  set :client_id, key_config['client_id']
  set :client_secret, key_config['client_secret']

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :yammer, settings.client_id, settings.client_secret
  end

  scheduler = Scheduler.new#.start

  poller = YammerPoller.new(scheduler)
  if poller.authorised?
    puts "Hooray!  Authorised!"
    POLLING_THREAD = Thread.new { poller.poll }
  end
end

get '/' do
  puts "Settings"
  erb :index
end

get '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  # do whatever you want with the information!
  puts "Auth: #{auth.credentials.token} expires? #{auth.credentials.expires}"
  File.write('token', auth.credentials.token)
  redirect to('/done')
end

get '/done' do
  erb :done
end

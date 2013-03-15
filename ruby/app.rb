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

  scheduler = Scheduler.new
  scheduler.start

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

get '/display/:module/:screen_id' do
  screen = Screen.find_by_id(params[:screen_id])
  puts "Found screen #{screen.inspect}"
  erb params[:module].to_sym, layout: true, views: 'lib/screen_modules', locals: {screen: screen} 
end

get '/fdisplay/jenkins/12345' do
  m = { 'body' => { 'plain' => 'Build Results - MASTER #7060 FAILURE http://jenkins.int.yammer.com/job/MASTER/7059/ Last successful build was: MASTER #7055'} }
  mm = {msg: m, responses: [m,m]}
  s=Screen.new(mm,[Jenkins])
  puts "$$$$$$$$$$$$$$$ #{s.inspect}"
  erb :jenkins, layout: true, views: 'lib/screen_modules', locals: {screen: s} 
end


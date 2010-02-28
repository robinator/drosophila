# usercrm.rb
require 'rubygems'
require 'sinatra'
require 'sequel'
require 'activerecord'
require 'lib/config'
require 'lib/models'

enable :sessions

before do
  @projects = Project.all
end

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

get '/logout' do
  session[:in] = 'no'
  redirect '/'
end

post '/login' do
  if yes
    session[:in] = 'yes'
    redirect '/'
  else
    @message = "No"
    erb :login
  end
end

get '/projects' do
  erb :projects
end
post '/projects/*/bugs' do
  @project = Project.find(:first, :conditions => {:name => params[:splat]})
  @bug = Bug.new(:project_id => @project.id, :short => params[:short], :long => params[:long], :who => params[:who], :created_at => Time.now)
  @bug.save
  redirect "/projects/#{params[:splat]}"
end
get '/projects/*/bugs/*' do
  @bug = Bug.find(params[:splat].last)
  erb :bug
end
get '/projects/*/delete' do
  @project = Project.find(:first, :conditions => {:id => params[:splat]})
  @project.destroy
  redirect '/projects'
end
get '/projects/*' do
  @project = Project.find(:first, :conditions => {:name => params[:splat]})
  @bugs = Bug.find(:all, :conditions => {:project_id => @project.id})
  erb :project
end
post '/projects' do
  @project = Project.new(:name => params[:name].to_s, :created_at => Time.now)
  @project.save
  redirect '/projects'
end

def yes
  params[:one] == ONE && params[:two] == TWO
end
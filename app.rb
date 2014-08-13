require 'mongoid'
set :public_folder, File.dirname(__FILE__) + "/public"

Mongoid.load!("mongoid.yml")

class Lead
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :church_size
end


def authorized?
  @auth = Rack::Auth::Basic::Request.new(request.env)
  @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['AUTH_USERNAME'],ENV['AUTH_PASSWORD']]
end

def authenticate_user!
  if !authorized? && settings.production?
    response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
    throw(:halt, [401, "Authentication required!"])
  end
end

get '/' do
  erb :index
end

post '/leads' do
  @lead = Lead.new(email:params[:email],church_size:params[:churchSize])

  if @lead.save
    status 201
  else
    status 500
  end
end

get '/leads' do
  authenticate_user!
  @leads = Lead.all

  erb :lead_index
end

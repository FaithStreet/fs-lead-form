require 'mongoid'
set :public_folder, File.dirname(__FILE__) + "/public"

Mongoid.load!("mongoid.yml")

class Lead
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :church_size
end


get '/' do
  erb :index
end

post '/leads' do
  @lead = Lead.create!(email:params[:email],church_size:params[:churchSize])
end

get '/leads' do
  @leads = Lead.all

  erb :lead_index
end

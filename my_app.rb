# my_app.rb 

require 'sinatra'

class MyApp < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/home' do
    erb :index
  end

  get '/about' do
    erb :about
  end

  get '/portfolio' do
    erb :portfolio 
  end

  get '/contact' do
    erb :contact
  end

  get "/cute_pictures_of_animals" do
    erb :cute_pictures_of_animals
  end


  
end

# my_app.rb 

require 'sinatra'
require 'yaml'

class MyApp < Sinatra::Base

  before do
   @posts = Dir.glob("views/posts/*.erb").map do |post_name| 
      post_name.split("/").last.slice(0..-5)
    end
  end

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

  get '/blog' do
    erb :blog
  end


  get "/cute_pictures_of_animals" do
    erb :cute_pictures_of_animals
  end

  get "/blog/:post_name" do
    page = erb("/posts/#{params[:post_name]}".to_sym, layout: false)
    page_body = page.split("\n\n", 2).last
    erb page_body
  end

  def meta_data
    if @metadata
      @metadata
    else 
      @metadata = {}
      @posts.each do |post|
      html = erb("/posts/#{post}".to_sym, layout: false) #returns string with the post as a string
      meta = YAML.load(html.split("\n\n", 2).first) #returns hash
      metadata[post] = meta #puts hash into hash
    end
      @metadata
    end
  end

end

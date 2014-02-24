  # my_app.rb 

require 'sinatra'
require 'yaml'
require 'json'
set :json_encoder, :to_json

class MyApp < Sinatra::Base
  # helpers Sinatra::JSON

  before do
   @posts = Dir.glob("views/posts/*.erb").map do |post_name| 
      post_name.split("/").last.slice(0..-5)
    end
   @sorted_posts = meta_data.sort_by {|post, date_hash| date_hash["date"]}.reverse

  end

  #  @body_class=Dir.glob("views/*.erb").map do |post_name| 
  #   post_name.split("/").last.slice(0..-5)
  # end

  get '/' do
    @body_class = "index"
    erb :index
  end

  get '/home' do
    @body_class = "index"
    erb :index
  end

  get '/about' do
    @body_class = "about"
    erb :about
  end

  get '/about.json' do
    content_type :json
    {key:"hello"}.to_json
  end

  get '/portfolio' do
    @body_class = "portfolio_body"
    erb :portfolio 
  end

  get '/portfolio/dinosaurs' do
    @body_class = "portfolio_body"
    erb :dinosaurs
  end

  get '/blog' do
    @body_class = "blog_body"
    erb :blog
  end

  get "/cute_pictures_of_animals" do
    erb :cute_pictures_of_animals
  end

  get "/blog/:post_name" do
    @body_class = "post_body"
    page = erb("/posts/#{params[:post_name]}".to_sym, layout: false)
    p page
    page_body = page.split("\n\n", 2).last
    erb page_body
  end

  get "/blog/:post_name.:format?",  :provides => [:json] do
    content_type :json
    # {hello: "blog"}.to_json
    # page = erb("/posts/#{params[:post_name]}".to_sym, layout: false)
    page_hash = {}
    page_hash[:body] = "hello"
    p page_hash
    page_hash.to_json
  end

  def meta_data
    if @metadata
      @metadata
    else 
      @metadata = {}
      @posts.each do |post|
        html = erb("/posts/#{post}".to_sym, layout: false) #returns text of post as a string (html)
        meta = YAML.load(html.split("\n\n", 2).first) #returns hash, keys are post names, values are hashes with dates
        @metadata[post] = meta #puts hash into hash
      end
      @metadata
    end
  end

end

require 'sinatra'
require 'yaml'
require 'json'
set :json_encoder, :to_json

class MyApp < Sinatra::Base

  before do
   @posts = Dir.glob("views/posts/*.erb").map do |post_name|
      post_name.split("/").last.slice(0..-5)
    end
   @sorted_posts = meta_data.sort_by {|post, date_hash| date_hash["date"]}.reverse
  end

  get '/' do
    @body_class = "index"
    erb :index
  end

  get '/about' do
    @body_class = "about"
    erb :about
  end

  get '/projects' do
    # @body_class = "portfolio_body"
    erb :projects
  end
  get '/portfolio' do
    @body_class = "portfolio_body"
    erb :portfolio
  end

  get '/blog' do
    @body_class = "blog_body"
    page = erb("/posts/#{@sorted_posts.first.first}".to_sym, layout: false)
    page_body = page.split("\n\n", 2).last
    @current = page_body
    erb :blog
  end

  get "/blog/:post_name" do
    @body_class = "blog_body"
    page = erb("/posts/#{params[:post_name]}".to_sym, layout: false)
    page_body = page.split("\n\n", 2).last
    @current = page_body
    erb :blog
  end

  # get "/blog/:post_name.:format?",  :provides => [:json] do
  #   content_type :json
  #   page_hash = {}
  #   page_hash[:body] = "hello"
  #   page_hash.to_json
  # end

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

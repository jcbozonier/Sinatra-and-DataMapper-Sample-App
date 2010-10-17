require 'sinatra'
require 'DataMapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end

DataMapper.finalize

# automatically create the post table
DataMapper.auto_upgrade!

get '/create_blog_post' do
  erb :create_blog_post
end

post '/blog_post' do
  post = Post.create(
      :title => params[:blog_title], 
      :body => params[:blog_body], 
      :created_at => Time.now)
  
  redirect '/blog_posts'
end

get '/blog_posts' do
    @posts = Post.all(:order => [ :id.desc ], :limit => 20)
    @posts = [] if @posts == nil
    
    erb :blog_posts
end
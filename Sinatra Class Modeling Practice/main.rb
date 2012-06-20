require 'rubygems'
require 'sinatra'
require 'data_mapper'
gem 'dm-mysql-adapter'

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, 'mysql://root:Hgo728898@localhost/class')

class Region  
  include DataMapper::Resource  
  property :id, Serial  
  property :name, Text, :required => true
  property :complete, Boolean, :required => true, :default => false

  has n, :locations
end

class Location
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  belongs_to :region
  has n, :floors
end

class Floor
  include DataMapper::Resource
  property :id, Serial
  property :number, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  belongs_to :location
  has n, :rooms
end

class Room
  include DataMapper::Resource
  property :id, Serial
  property :name, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  belongs_to :floor
  has n, :areas
end

class Area
  include DataMapper::Resource
  property :id, Serial
  property :complete, Boolean, :required => true, :default => false
  belongs_to :room
  has n, :points
end

class Point
  include DataMapper::Resource
  property :id, Serial
  property :complete, Boolean, :required => true, :default => false

  belongs_to :area
end

DataMapper.finalize.auto_upgrade!

helpers do  
    include Rack::Utils  
    alias_method :h, :escape_html  
end

get '/' do  
  @regions = Region.all :order => :id.desc    
  erb :home  
end

post '/' do  
  r = Region.new  
  r.name = params[:name]    
  r.save  
  redirect '/'  
end

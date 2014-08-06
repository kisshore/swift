class SearchController < ApplicationController
  require 'mongo'
  
  def index
    client = Mongo::Connection::new
    
    render "/search/index"
    
  end
  
  
  def search
    p  params
    #write code to search in mongo DB database.
    # mongo test123 --eval 'printjson(db.actorslist.find({$text: {$search: "hero"}}).forEach(printjson))'
    render "/search/index"
  end
  
  
end

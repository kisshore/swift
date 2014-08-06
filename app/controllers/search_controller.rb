class SearchController < ApplicationController
  require 'mongo'
  
  def index
      conn = Mongo::Connection::new
    @@db = conn.db("swift_development")
    @@coll = @@db.collection("metadata")
    @@coll.create_index({"$**" => "text"})

    
    render "/search/index"
    
  end
  
  
  def search
    p  params
    query = params.require(:q)
    puts @@coll.find({"$text" => {"$search" => query}}).to_a
    #write code to search in mongo DB database.
    # mongo test123 --eval 'printjson(db.actorslist.find({$text: {$search: "hero"}}).forEach(printjson))'
    render "/search/index"
  end
  
  
end

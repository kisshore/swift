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
    puts @results = @@coll.find({"$text" => {"$search" => query}}).to_a
    #@results = [{"component_type" => "object", "name" => "NTR", "party" => "TDP"},{"component_type" => "container", "name" => "MODI", "party" => "BJP"},{"component_type" => "object", "name" => "PJR", "party" => "Congress"}]
    #write code to search in mongo DB database.
    # mongo test123 --eval 'printjson(db.actorslist.find({$text: {$search: "hero"}}).forEach(printjson))'
   # render json: @results
    render "/search/index"
  end
  
  
end

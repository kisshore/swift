class SwiftController < ApplicationController
  require 'httmultiparty'
  require "json"
  require 'net/ping'
  require 'fog'
  require 'mongo'
  
  
  KEYSTONE_URL = "http://192.168.5.75:5000/v2.0/tokens"
  SWIFT_URL = "http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7"
  
  
  
  def generate_token
  @@service = Fog::Storage.new({:provider => 'OpenStack',:openstack_username => "swift", :openstack_api_key => "root",:openstack_auth_url  => "http://192.168.5.75:5000/v2.0/tokens", :openstack_tenant => "service" })
    @auth_token= @@service.instance_values["auth_token"]
    
   conn = Mongo::Connection::new
    @@db = conn.db("swift_development")
    @@coll = @@db.collection("metadata")
    @@coll.create_index({"$**" => "text"})
    #list_containers
    redirect_to dashboard_url
  end
  
  
  def list_containers  
    
    p @@service
    @containers = Array.new
    @objects = Hash.new
    @@service.directories.each do |container|
      @containers.push(container.key)
    end
   p @containers
    @containers.each do |c|
      cont = @@service.directories.get c
      @objects[c] = cont.files
    end
    
    respond_to do |format|
      format.html {render "dashboard"}
    end
    
 #   render "dashboard"
  end
  
  def create_container
    puts "************************************ Creating Container *************"
    c_name = params.permit(:container_name)
    p c_name = c_name["container_name"]
    
    metadata = Hash.new
    metadata["container_name"] = c_name
    metadata["component_type"] = "container"
     id = @@coll.insert(metadata)
    p id
    
    p @@service
    @@service.directories.create :key => c_name
    list_containers
  
  end
  
  def delete_container
    puts "************************************ Creating Container *************"
     c_name = params.permit(:container_name)
    p c_name = c_name["container_name"]
    cont = @@service.directories.get c_name
    list_containers
  end
  
  def create_object
    
    puts params
    meta_hash = params.require(:meta)
    metadata = Hash.new
    (0..((meta_hash.count)*0.5)).each do |x|
      p metadata[meta_hash["name_"+x.to_s]] 
      p meta_hash["value_"+x.to_s]
      metadata[meta_hash["name_"+x.to_s]] = meta_hash["value_"+x.to_s]
    end
    p metadata
    p @@service
    
    @cont_name = params.require(:container_name)
    metadata["container_name"] = @cont_name
    metadata["object_name"] = params.require(:object_name)
   
    container = @@service.directories.get @cont_name
      @obj_file = params.require(:drum).permit(:obj)
    p f=  @obj_file["obj"]    
    metadata["original_filename"] = f.original_filename
    metadata["content_type"] = f.content_type
    metadata["component_type"] = "object"
    
    h = container.files.create :key => f.original_filename, :body=>f
    id = @@coll.insert(metadata)
    p id
    p h 
    if(h)
      #write code to insert object name, meta data into MongoDb collections.
    end
    
    
    redirect_to :back
  end
    
   
  
  def list_objects
    p params
    container =  params.require(:container)
    object = params.require(:object)
    object = object+"."+params.require(:format)
    p container
    p object
    dir = @@service.directories.get container
    obj = dir.files.get(object)
    p dir
    p obj
    send_data @@service.get_object(container,object).body
   # redirect_to :root

  end
   
  def list_objects2
     p "downloading files.."
    dir= @@service.directories.get("NaAg")
    p dir
    s_file = dir.files.first
    p s_file
    foo= File.open('kishore.mp3', 'w') do | f |
        dir.files.first do | data, remaining, content_length |
        f.syswrite data
        end  
        end
    send_data s_file.body , :filename => "trigger.mp3"
    
    
    p "This is what i know..!"
    
    #redirect_to :back
  end
  
  
  def delete_object
    
      
  end
  
  
  
  
  
end

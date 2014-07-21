class SwiftController < ApplicationController
  require 'httmultiparty'
  require "json"
  require 'net/ping'
  require 'fog'
  
  
  KEYSTONE_URL = "http://192.168.5.75:5000/v2.0/tokens"
  SWIFT_URL = "http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7"
  
  def generate_token
  @@service = Fog::Storage.new({:provider => 'OpenStack',:openstack_username => "swift", :openstack_api_key => "root",:openstack_auth_url  => "http://192.168.5.75:5000/v2.0/tokens", :openstack_tenant => "service" })
    
    @auth_token= @@service.instance_values["auth_token"]
    
    list_containers
    
  end
  
  
  def list_containers  
    p @@service
    @containers = Array.new
    @objects = Hash.new
    
    @@service.directories.each do |container|
      @containers.push(container.key)
      #@objects[container.key] = container.files
    end
    
    
    p @containers
  p "1"
    p "2"
    #p @objects
    p "3"
    
    render "dashboard"
  end
  
  def create_container
    puts "************************************ Creating Container *************"
    c_name = params.permit(:container_name)
    p c_name = c_name["container_name"]
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
   
    p @@service
    
    @cont_name = params.require(:container_name)
    container = @@service.directories.get @cont_name
      @obj_file = params.require(:drum).permit(:obj)
    p f=  @obj_file["obj"]
    p f
    
    h = container.files.create :key => "teste.mp3", :body=>f
    p h 
    redirect_to :back
  end
    
   
  
  def list_objects
    redirect_to :back
  end
  
  def delete_object
    
      
  end
  
  
  
  
  
end

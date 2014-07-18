class SwiftController < ApplicationController
  require 'httmultiparty'
  require "json"
  require 'net/ping'
  include HTTMultiParty
  
  KEYSTONE_URL = "http://192.168.5.75:5000/v2.0/tokens"
  SWIFT_URL = "http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7"
  
  def generate_token
    begin
    puts "****************** Generating Authenication token... ************"   
    @auth_resp = HTTParty.post(KEYSTONE_URL,
      {
        :headers => {'Content-Type' => "application/json", "Accept" => "application/json"},
        :body => {"auth" =>{"passwordCredentials" =>{"username" => "swift","password" =>"root"},"tenantName" =>"service" }}.to_json
       })
    puts @auth_resp
    puts @auth_token = @auth_resp["access"]["token"]["id"]
    if (Authentications.create(:user => "test", :token => @auth_token))
       flash[:id_notice]= "New authentication token has benn generated.!"
    else
      flash[:id_notice]= "Unable to create authentication token.. Please check the log.!"
    end
    puts "**"*40
    rescue
      puts "Saved!"
    ensure
    list_containers
    end
  end
  
  
  def list_containers
    puts "************************************ Listing Containers *************"
    begin
    @auth_token = Authentications.last.token
     #cont_resp = HTTParty.get(SWIFT_URL+"?format=json", { :headers => {'X-Auth-Token' => @auth_token} })   
    puts cont_resp
    puts cont_resp.class
    puts cont_resp.headers
    puts cont_resp.body
      
     p @cont_json
       #@containers = JSON.parse(cont_resp.body)
      rescue
        @containers = [{"name"=> "conatiner1","count"=> 23, "size" =>10},{"name"=> "conatiner2","count"=> 23, "size" =>10},{"name"=> "conatiner3","count"=> 23, "size" =>10},{"name"=> "conatiner4","count"=> 23, "size" =>10}]
      #@containers = JSON.parse(cont_resp.body)
     
      puts "**"*40
    ensure
    render "dashboard"
      end
  end
  
  def create_container
    puts "************************************ Creating Container *************"
    c_name = params.permit(:container_name)
    p c_name = c_name["container_name"]
    @cont_url = SWIFT_URL+"/#{c_name}"
    puts "############" + @cont_url
    @auth_token = Authentications.last.token
    cont_resp = HTTParty.put(@cont_url, {:headers => {'X-Auth-Token' => @auth_token}})  
    puts cont_resp
    puts "**"*50
    list_containers
  
  end
  
  def delete_container
    puts "************************************ Creating Container *************"
     c_name = params.permit(:container_name)
    p c_name = c_name["container_name"]
    
    @auth_token = Authentications.last.token
    @cont_url = SWIFT_URL+"/#{c_name}"
    cont_resp = HTTParty.delete(@cont_url, {:headers => {'X-Auth-Token' => @auth_token}})  
    list_containers
  end
  
  def create_object
    puts params
    #curl –X PUT -i  -H "X-Auth-Token: $auth_token" -T JingleRocky.jpg $swift_url/container/obj
  
  service = Fog::Storage.new({
  :provider            => 'OpenStack',   # OpenStack Fog provider
  :openstack_username  => "swift",      # Your OpenStack Username
  :openstack_api_key   => "root",      # Your OpenStack Password
  :openstack_auth_url  => KEYSTONE_URL,
    :openstack_tenant => "service"
})
    p service 
    @cont_name = params.require(:container_name)
    container = service.directories.get "kishore"
      @obj_file = params.require(:drum).permit(:obj)
    p f=  @obj_file["obj"]
    p f
    
    h = container.files.create :key => "teste.mp3", :body=>f
    p h 
    redirect_to :back
  end
    
   
  
  def list_objects
    @auth_token = Authentications.last.token
     cont_resp = HTTParty.get(SWIFT_URL+"?format=json", { :headers => {'X-Auth-Token' => @auth_token} })   
    @containers = JSON.parse(cont_resp.body)
    @containers.each do |x|
      @ob_url = SWIFT_URL+"/"+x["name"]
      
      obj_resp =  HTTParty.get(@ob_url+"?format=json", { :headers => {'X-Auth-Token' => @auth_token} })   
      
      p obj_resp
      p JSON.parse(obj_resp.body)
      
    end
    redirect_to :back
  end
  
  def delete_object
    
      
  end
  
  
  
  
  
end

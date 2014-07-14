class SwiftController < ApplicationController
  KEYSTONE_URL = "http://192.168.5.75:5000/v2.0/tokens"
  SWIFT_URL = "http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7"
  
  def generate_token
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
    list_containers
   
  end
  
  
  def list_containers
    puts "************************************ Listing Containers *************"
    @auth_token = Authentications.last.token
    cont_resp = HTTParty.get(SWIFT_URL+"?format=json", { :headers => {'X-Auth-Token' => @auth_token} })   
    puts cont_resp
    puts cont_resp.class
    puts cont_resp.headers
    puts cont_resp.body
      
      
      @cont_json = JSON.parse(cont_resp.body)
      p @cont_json
      p @cont_json.class
        @cont_json.each do |x|
          p x
        end
          
        @containers = JSON.parse(cont_resp.body)
     
      puts "**"*40
    render "dashboard"
  end
  
  def create_container
    puts "************************************ Creating Container *************"
    c_name = params.permit(:container_name)
    p c_name
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
    c_name = 
    @auth_token = Authentications.last.token
    @cont_url = SWIFT_URL+"/#{c_name}"
    cont_resp = HTTParty.delete(@cont_url, {:headers => {'X-Auth-Token' => @auth_token}})  
    list_containers
  end
  
  def create_object
  end
  
  def list_objects
  end
  
  def delete_object
  end
  
  
  
  
  
end

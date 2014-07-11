class WelcomeController < ApplicationController
  require "json"
  require 'net/ping'
  
  def index
  end
  
  def upload
    
    generate_token
      if(@a_token_id)
        flash[:id_notice]= "New authentication token has benn generated.!"
    else
      flash[:id_notice]= "Looks like there is an error.. unable to create authentication token, sorry.!"
    end
    
    list_containers
    
    
    
    
  end
  
  def upload_swift
    p "$"*100
    puts params 
    redirect_to :back
    
  end
  
  private
  
  def generate_token
    p "*"*100
      if(Net::Ping::External.new("192.168.5.75").ping?)
        p "192.168.5.75  is alive!"
        a_token = %x(  curl -H "Content-Type: application/json" -d '{"auth":{"passwordCredentials":{"username":"swift","password":"root"},"tenantName":"service" }}' http://192.168.5.75:5000/v2.0/tokens )
        @a_token = JSON.parse(a_token) 
        @a_token_id = @a_token["access"]["token"]["id"]
      end
   p "*"*100 
  end
  
  def list_containers
    p "*"*100 
    if(@a_token_id)
    k = %x(curl –X GET -i  -H "X-Auth-Token:  #{@a_token_id}"   http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7
    else
      @error_message= "Invalid token"
    end
    p k
    p "*"*100 
  end
  
  
  def create_container
  end
  def list_objects
  end
  def create_object
  end
  def edit_container
  end
  def edit_object
  end
  def delete_container
  end
  def delete_object
  end
  
  
  
  
  
  
end

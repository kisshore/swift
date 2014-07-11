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
    
  end
  
  def upload_swift
    p "$"*100
    puts params 
    redirect_to :back
    
  end
  
  private
  
  def generate_token
    p "**"*100
      if(Net::Ping::External.new("192.168.5.75").ping?)
        p "192.168.5.75  is alive!"
        a_token = %x(  curl -H "Content-Type: application/json" -d '{"auth":{"passwordCredentials":{"username":"swift","password":"root"},"tenantName":"service" }}' http://192.168.5.75:5000/v2.0/tokens )
        @a_token = JSON.parse(a_token) 
        @a_token_id = @a_token["access"]["token"]["id"]
      end
   p "**"*100 
   
  end
  
  
end

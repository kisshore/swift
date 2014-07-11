class WelcomeController < ApplicationController
  def index
  end
  
  def upload
  end
  
  def upload_swift
    p "$"*100
    puts params 
    
   p "**"*100
    k = %x(ping -c 2 192.168.5.75)
    if(k.length > 0)
    @ex = %x(  curl -H "Content-Type: application/json" -d '{"auth":{"passwordCredentials":{"username":"swift","password":"root"},"tenantName":"service" }}' http://192.168.5.75:5000/v2.0/tokens )
    
    p @ex
   p "**"*100 
    end
    redirect_to :back
    
  end
end

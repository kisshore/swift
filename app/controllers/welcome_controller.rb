class WelcomeController < ApplicationController
  require "json"
  require 'net/ping'
  
  def index
  end
 
  def create_test_token
       generate_token
      if(@a_token_id)
        flash[:id_notice]= "New authentication token has benn generated.!"
    else
      flash[:id_notice]= "Looks like there is an error.. unable to create authentication token, sorry.!"
    end
    redirect_to :back
  end
  
  
  def upload
    
    @containers = {:list => [{"name" => "hello"},{"boblo" => "bai"}], :count => 2}
    list_containers
    @containers 
    p @containers
    
    
  end
  
  
  
  def create_container
    p "**************CREATING CONTAINER---------------"
      @a_token_id = Authentications.where(:user => "test").last.token
    
    @c_name =params.require(:container_name)
    p @c_name
    @url_swift = "http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7/"+@c_name
    @status= %x(curl –X PUT -i -H "X-Auth-Token: #{@a_token_id}" "#{@url_swift}" )
    flash[:id_notice]= "Container created!"
    redirect_to :back
  end
  
   def delete_container
  end
  
  
  
  private
  
  def generate_token
    p "****************************generating token****************"
    
    if(Net::Ping::External.new("192.168.5.75").ping?)
        p "192.168.5.75  is alive!"
        a_token = %x(  curl -H "Content-Type: application/json" -d '{"auth":{"passwordCredentials":{"username":"swift","password":"root"},"tenantName":"service" }}' http://192.168.5.75:5000/v2.0/tokens )
        @a_token = JSON.parse(a_token) 
         @a_token_id = @a_token["access"]["token"]["id"]
      
      Authentications.create(:user => "test", :token => @a_token_id)
      p "token generated"+@a_token_id
    else
      p "************ Jim, your 192.168.5.75 is dead***************"
      end
   
  end
  
  def list_containers
    p "**************Listing Containers*************"
     if(Net::Ping::External.new("192.168.5.75").ping?)
        p "192.168.5.75  is alive!"
        @a_token_id = Authentications.where(:user => "test").last.token
        if(@a_token_id)
          k = %x(curl –X GET -i  -H "X-Auth-Token:  #{@a_token_id}"   http://192.168.5.75:8080/v1/AUTH_8e3870634f9748368c04e91cf379e5f7?format=json)
          p k
          parse_response(k)
        else
          p  "Invalid token"
        end
    p k
    p "*"*100
     end
  end
  
  
 
  
  def list_objects
  end
  def create_object
  end
  def edit_container
  end
  def edit_object
  end
  def delete_object
  end
  
  def parse_response(data)
    temparray = Array.new
    @containers = Hash.new
    data.each_line do |d|
      temparray.push(d)
      if(d.include?("Container-Count"))
        @containers[:count] = d.split(":").last.to_i 
      elsif(d.include?("Object-Count"))
        @containers[:object_count] =d.split(":").last.to_i 
      elsif(d.include?("Bytes-Used"))
        @containers[:size] =d.split(":").last.to_i 
      end
    end
    
    @containers[:list] = JSON.parse(temparray.last)
      
  end
  
  
  
  
end

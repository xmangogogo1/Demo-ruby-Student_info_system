require 'sinatra'
#require 'sinatra/reloader'  ----- heroku won't recognize this library
require 'sass'
require './student' 


#put at the very begining to use a sass(dynamic css filter)
get '/styles.css' do
   scss :styles   #相当于 erb :about; 使用default layout.erb
end



get '/' do
  @title = "Home"
  if session[:admin] 
  	erb :home, :layout => :logedinlayout
  else
  	erb :home
  end
end


get '/about' do
	@title = "About Our Project"
    if session[:admin] 
  		erb :about, :layout => :logedinlayout
  	else
  		erb :about
  	end
end


get '/contact' do
	@title = "Contact us"
     if session[:admin] 
  		erb :contact, :layout => :logedinlayout
  	else
  		erb :contact
  	end
end

get '/video' do
	 if session[:admin] 
  		erb :video, :layout => :logedinlayout
  	else
  		erb :video
  	end
end

get '/login' do	
	if session[:admin]
		erb :home, :layout => :logedinlayout
	else
		erb :login
	end
end


get '/logout' do
	session.clear
	redirect to '/login'
end 



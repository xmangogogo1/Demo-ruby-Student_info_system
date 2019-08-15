require 'dm-core'
require 'dm-migrations'
#require 'time'

#setup session
configure do
  enable :sessions
  set :username, "admin"
  set :password, "123"

end

#setup database
configure :development do
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/student.db") #create a student.db file if there is not 
end

#setup database
configure :production do 
  DataMapper::Logger.new($stdout, :debug)
  DataMapper.setup(:default, ENV['DATABASE_URL']) #when push to heroku, it is in deployment env
end


#ORM - map to students table in db
class Student
  include DataMapper::Resource 	
  property :id, Serial 
  property :fn, String
  property :ln, String
  property :bd, Date  ## in the form, this must also be date type!!!
  property :classes, String
  property :intro, Text
end


#ORM - map to comments table in db
class Comment
  include DataMapper::Resource
  property :id, Serial
  property :name ,String
  property :comment, Text
  property :created_at, Time
end

DataMapper.finalize








####################################################################
#styles

#for student details layout which url starts with /student/
get '/student/styles.css' do
   scss :styles   
end

get '/student/:id/styles.css' do
   scss :styles   
end

get '/comment/styles.css' do
   scss :styles   
end

get '/comment/:id/styles.css' do
   scss :styles   
end



####################################################################
#session
post '/login' do
  
  if params[:username] == settings.username && params[:password] == settings.password
    	session[:admin] = true
    	redirect to "/login"
  else
    halt 403, "wrong username / password, try again: #{params[:username]} , #{params[:password]}, should be : #{settings.username}, #{settings.password}"
  end
end




####################################################################
#student


#create student - step 1:
#passing an empty student obj to createStudent.erb, send this obj to studentForm
get '/student/create' do
    halt(403, 'Not Authorized') unless session[:admin]
    @student = Student.new

    if session[:admin]
      erb :createStudent, :layout => :logedinlayout
    else
      erb :createStudent
    end
end



#create student - after click save in the form -- step 2:
#pass the filled student obj back as a post reqesut,and add this new student into db 
post '/student' do
     @newStu = Student.create(params[:student])
     redirect to ("/student/#{@newStu.id}")

end



#check students list
get '/students' do
	 @students = Student.all 
	 if session[:admin]
  		erb :students, :layout => :logedinlayout
  	 else
	 	erb :students  
	 end 
end




#check each studuent detail --------this line must put behind get '/student/create' do, otherwise won't reach
get '/student/:id' do
    @student = Student.get(params[:id])
    if session[:admin]
  		erb :details, :layout => :logedinlayout
  	else
    	erb :details
	end
end





#edit the student info - click edit button - step 1 
#call the field form, pass student obj to the form, and show this record

get '/student/:id/edit' do
    halt(403, 'Not Authorized') unless session[:admin]
    @student = Student.get(params[:id])

    if session[:admin]
  		erb :editStudent, :layout => :logedinlayout
  	else
    	erb :editStudent
    end
end


#edit the student  - click save button from the form - step 2
#send the student obj to editStudent.erb, then hidden send the student.id back as put request
put '/student/:id' do
	halt(403, 'Not Authorized') unless session[:admin]
  if session[:admin]
    st = Student.get(params[:id])
      st.update(params[:student])
    redirect to ("/student/#{st.id}") 
  else
    redirect to "/"
  end
end



#delete the student - student.id get passed to form when press delete button, and it send back 
#the student.id as a delete request as hidden type
delete '/student/:id' do
	
   halt(403, 'Not Authorized') unless session[:admin]
   Student.get(params[:id]).destroy
   redirect to ("/students")	
end



####################################################################
#comment

#show comments
get '/comments' do
  @title = "Leave your Comment & Advice"
  @comments =Comment.all
  if session[:admin] 
  	erb :comment, :layout => :logedinlayout
  else
  	erb :comment
  end
end


#add new commnets
get '/comment/create' do
  if session[:admin]
  	erb :commentForm, :layout => :logedinlayout
  else
  	erb :commentForm
  end
end


#add new commnets
post '/comments' do
  @cmt = Comment.create(name: params[:name], comment: params[:comment], created_at: Time.now)
  redirect to '/comments'
  
end

#check comment detial
get '/comment/:id' do
    @cmt = Comment.get(params[:id])
	erb :commentDetail
    
end


not_found do
	@title = "404 Not Found"
	erb :notfound, :layout => :notfoundlayout
end




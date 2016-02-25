helpers do
	def current_user
		@current_user = User.find(session[:user_id]) if session[:user_id]
	end

	def check_flash
		@flash = session[:flash] if session[:flash]
		session[:flash] = nil
	end
end

before do
	current_user
	check_flash
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/login' do
	erb :login_form
end

post '/login' do
	username = params[:username]
	password = params[:password]

	user = User.find_by username: username, password: password
	if user
		session[:user_id] = user.id
		redirect '/'
	else
		session[:flash] = "Invalid login."
		redirect '/login'
	end
end

get '/logout' do
	session.clear
	redirect '/'
end

get '/signup' do
	@user = User.new
	erb :signup_form
end

post '/signup' do
	username = params[:username]
	email = params[:email]
	password = params[:password]

	@user = User.new username: username, email: email, password: password

	if @user.save
		session[:user_id] = @user.id
		redirect '/'
	else
		session[:flash] = "We could not create your user. You suck."
		redirect '/signup'
	end
end

get '/profile/edit' do
	@user = @current_user
	erb :profile_edit
end

post '/profile/edit' do
	username = params[:username]
	email = params[:email]
	password = params[:password]	

	@current_user.username = username
	@current_user.email = email
	@current_user.password = password if password
	if @current_user.save
		redirect '/'
	else
		session[:flash] = "Bad data, fool."
		redirect '/profile/edit'
	end
end

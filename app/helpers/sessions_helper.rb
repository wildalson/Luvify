module SessionsHelper
	# Logs in the given user
	def log_in(user)
		session[:user_id]=user.id
	end
	# Returns the current user
	def current_user
		if (user_id=session[:user_id])
			@current_user= @current_user ||= User.find_by(id: session[:user_id])
		elsif (user_id= cookies.signed[:user_id])
			raise
			user=User.find_by(id:user_id)
			if user && user.authenticate?(:remember,cookies[:remember_token])
				log_in user
				@current_user=user
			end
		end
	end
	# Returns true if the user is currently logged in 
	def logged_in?
		current_user.nil? #returns true if current_user is empty.
	end
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end
	# Logs out the current user
	def logout
		forget(current_user)
		session[:user_id]=nil
		@current_user=nil
	end
	# Remembers a user in a persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id]= user.id
		cookies.permanent[:remember_token]= user.remember_token
	end
	# Determining if we have the right user
	def current_user?(user)
		user==current_user
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url]= request.url if request.get?
	end
end

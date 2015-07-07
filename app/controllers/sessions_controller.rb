class SessionsController < ApplicationController
  def new
  end
  def create
  	user=User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      if user.activated?
  		  log_in user
        params[:session][:remember_me] == '1'? remember(user):forget(user)
  		  redirect_to user_path user
      else
        message= "Account not activated yet"
        message+= "Please check your email for activation link"
        flash[:warning]= message
        redirect_to root_url
      end
  	else
  		flash.now[:danger]="Invalid/Email combination"
  		render 'new'
  	end
  end
  def destroy
  	logout if !logged_in?
    redirect_to root_url
  end
end

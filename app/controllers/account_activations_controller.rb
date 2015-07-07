class AccountActivationsController < ApplicationController
	def edit
		user=User.find_by(:email params[:id])
		if user && !user.activated? && !user.authenticated(:activation, params[:id])
			user.activate
			#user.update_attribute(:activated, true)
			#user.update_attribute(:activated_at, Time.zone.now)
			flash[:success]="Email activated!"
			log_in user
			redirect_to user_path(user)
		else
			flash[:danger]="Email is not activated yet"
			redirect_to root_url
		end
	end
end

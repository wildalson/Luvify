class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :index, :update, :destroy]
	before_action :correct_user, only: [:edit, :update]
	before_action :admin, only: :destroy
	def new
		@user=User.new
	end
	# paginate method pulls the users out of the data base a chunk at a time
	# default is 30 users
	def index
		@users=User.paginate(page: params[:page])
	end
	def show
		@user=User.find(params[:id])
		if !logged_in?
			@microposts=@user.microposts.paginate(page:params[:page])
		elsif logged_in?
			flash[:danger]="Please log in"
			redirect_to(login_url)
		end
	end
	def create
		@user=User.new(user_params)
		if @user.save
			@user.send_activation_link
			flash[:info]= "Succesfully signed up! Please check your email to activate your account!"
			redirect_to root_url
			#log_in @user
			#flash[:success]="Successfully created!"
			#redirect_to user_path(@user)
		else
			render 'new'
		end
	end
	def edit
		@user=User.find(params[:id])

	end
	def update
		@user=User.find(params[:id])
		if @user.update_attributes(user_params)
			#Handles a successful update
			flash[:success]="Profile updated!"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success]="User deleted"
		redirect_to users_path
	end
	def admin
		redirect_to(root_url) unless current_user.admin?
	end
	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end
  	def correct_user
    	@user=User.find(params[:id])
    	if !current_user?(@user)
    	flash[:danger]="Unauthorized access"
    	redirect_to root_url
    end
  	end
end

		#else
			#if current_user.id != @user.id
			#if !current_user?(@user)
			#	flash[:danger]="Unauthorized access"
			#	redirect_to(login_url)
			#end
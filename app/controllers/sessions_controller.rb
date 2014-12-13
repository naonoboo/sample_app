class SessionsController < ApplicationController
  def new
  	
  end

  def create
=begin
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
=end
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
  		sign_in user
  		redirect_to user
  	else
  		flash.now[:error] = 'Invalid email/password combination' # 誤りあり！
  		render 'new'
  	end
  end

  def destroy
  	sign_out
    redirect_to root_url
  end
end

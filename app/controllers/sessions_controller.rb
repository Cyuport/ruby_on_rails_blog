class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
        #redirect_to root_url
      end

    else
      # 创建一个错误消息
      flash.now[:danger] = '邮件地址或密码错误！' # 不完全正确
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to articles_path
  end
end

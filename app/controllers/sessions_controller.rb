class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # 登入用户，然后重定向到用户的资料页面
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
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

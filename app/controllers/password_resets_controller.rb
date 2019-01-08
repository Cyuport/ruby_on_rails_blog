class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # 第一种情况
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "发送带有密码重置说明的电子邮件"
      redirect_to root_url
    else
      flash.now[:danger] = "未找到电子邮件地址"
      render 'new'
    end
  end

  def edit
  end
  
   def update
    if params[:user][:password].empty?                  # 第三种情况
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # 第四种情况
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "密码已重置"
      redirect_to @user
    else
      render 'edit'                                     # 第二种情况
    end
   end
   
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 确保是有效用户
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "密码重置已过期。"
        redirect_to new_password_reset_url
      end
    end
end

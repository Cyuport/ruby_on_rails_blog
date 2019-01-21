class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "微博发布成功!"
      redirect_to micropost_path
    else
        @feed_items = []
        flash[:danger] = "内容为空的微博是不能发布的"
        #render 'static_pages/home'
        redirect_to micropost_path
    end
  end

  def destroy
       @micropost.destroy
    flash[:success] = "微博已删除"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      #redirect_to root_url if @micropost.nil?
      redirect_to request.referrer if @micropost.nil?
     end
end
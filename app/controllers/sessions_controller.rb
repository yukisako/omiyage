class SessionsController < ApplicationController

  def callback
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    
    client_rest = Twitter::REST::Client.new do |config|
      config.consumer_key        = "dsFcWBVjn8BS6gyKv2q6X0QSw"
      config.consumer_secret     = "oTRyRiDash7XUfmwmJGrg1LXbeOr1jjtzZDDECt0MSuLAzDx67"
      config.access_token        = "3758421078-JoPRu04i3hawTTwmw9ThjQ7O8ZGLy5HzBYgzmME"
      config.access_token_secret = "y8EAWO1r4pBKTSvzfKh9itYfnsmaRVNAlSi5r8SfwyEQk"
    end
    randam = rand(10000)
    client_rest.update "@yuki_99_s 新しく人がログインしました。 #{randam}"
    redirect_to root_path
  end

  def new
    redirect_to new_item_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:session][:uuid].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info] = "logged in as #{@user.name}"
      redirect_to @user
    else
      flash[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

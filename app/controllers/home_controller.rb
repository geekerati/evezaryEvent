class HomeController < ApplicationController
  def switch
    user_agent = UserAgent.parse(request.user_agent)
    if user_agent.mobile?
      redirect_to mobile_index_path({s: params[:s]})
    else
      redirect_to home_index_path({s: params[:s]})
    end
  end
  
  def download_image
    send_file Rails.root+"app/assets/images/blog_posting.jpg", :x_sendfile => true,
    :type=>"image/jpg", :filename => "blog_posting.jpg", :disposition => 'attachment'
  end  
  
  def index
  end

  def popUp_1
    render layout: false
  end

  def popUp_2  
    device = "pc"
    user_agent = UserAgent.parse(request.user_agent)
    device = "mobile" if user_agent.mobile?
    @log = AccessLog.new(ip: request.remote_ip, device: device)
    @log.location = @log.get_location || "서울시 강남구 삼성동 91-25"
    @log.save
    render layout: false
  end

  def popUp_3
    render layout: false
  end
  def popUp_4
    render layout: false
  end
  def popUp_5
    render layout: false
  end
  def popUp_blog
    render layout: false
  end
end
class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
  belongs_to :gift
  
  validates :dest_phone, presence: true
  validates :send_phone, presence: true
  validates :msg_body, presence: true
  
  def send_mms
    url = "http://api.openapi.io/ppurio/1/message/mms/minivertising"
    api_key = Rails.application.secrets.apistore_key
    time = (Time.now + 5.seconds)
    file = File.new("./app/assets/images/mms_to_user.jpg",'rb')
    res = RestClient.post(url,
      {
        "send_time" => time.strftime("%Y%m%d%H%M%S"), 
        "dest_phone" => dest_phone, 
        "dest_name" => send_name,
        "send_phone" => send_phone, 
        "send_name" => send_name,
        "subject" => subject,
        "apiVersion" => "1", 
        "id" => "minivertising", 
        "msg_body" => msg_body,
        "file" => file,
        multipart: true
      },
      content_type: 'multipart/form-data',
      'x-waple-authorization' => api_key
    )
    cmid = JSON.parse(res)["cmid"]
    call_status = String.new
    while call_status.empty? or call_status == "result is null"
      sleep(5.seconds)
      call_status = report(cmid, time)
    end
  end
  
  def report(cmid, time)
    api_key = Rails.application.secrets.apistore_key
    url = "http://api.openapi.io/ppurio/1/message/report/minivertising?cmid="+cmid
    result = RestClient.get(url, 'x-waple-authorization' => api_key)
    call_status = JSON.parse(result)["call_status"].to_s
    self.sent_at = time
    self.cmid = cmid
    self.result = result
    self.call_status = call_status
    self.save!    
    return call_status
  end
end

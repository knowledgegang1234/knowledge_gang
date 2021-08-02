class AttachmentsController < ApplicationController
  protect_from_forgery with: :null_session

  def image_upload
    Cloudinary::Uploader.upload("dog.mp4", 
    :folder => "my_folder/my_sub_folder/", :public_id => "my_dog", :overwrite => true, 
    :notification_url => "https://mysite.example.com/notify_endpoint", :resource_type => "video")

    result = Cloudinary::Uploader.upload("data:image/png;base64,#{response['qr_content']}", :folder => "bharatqr/#{Date.today.to_s}/")

    result = {"file" => {"url" =>  'https://cdn0.desidime.com/cdn-cgi/image/fit=contain,f=auto,onerror=redirect,w=640,h=360,q=90/attachments/photos/660930/original/AmazonSale.jpg', "id" => 'https://cdn0.desidime.com/cdn-cgi/image/fit=contain,f=auto,onerror=redirect,w=640,h=360,q=90/attachments/photos/660930/original/AmazonSale.jpg'}  }
    render json: result, status: 200
  end
end
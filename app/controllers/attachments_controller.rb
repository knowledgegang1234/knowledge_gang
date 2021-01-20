class AttachmentsController < ApplicationController
  protect_from_forgery with: :null_session

  def image_upload
    result = {"file" => {"url" =>  'https://cdn0.desidime.com/cdn-cgi/image/fit=contain,f=auto,onerror=redirect,w=640,h=360,q=90/attachments/photos/660930/original/AmazonSale.jpg', "id" => 'https://cdn0.desidime.com/cdn-cgi/image/fit=contain,f=auto,onerror=redirect,w=640,h=360,q=90/attachments/photos/660930/original/AmazonSale.jpg'}  }
    render json: result, status: 200
  end
end
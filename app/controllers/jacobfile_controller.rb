class JacobfileController < ApplicationController
  skip_before_action :check_if_login_required
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token
  layout false

  def stats
    # do http get to localhost:9293 to get puma stats
    require 'net/http'
    require 'uri'

    uri = URI.parse('http://127.0.0.1:9293/stats')
    response = Net::HTTP.get_response(uri)
    # return json response
    render json: response.body    
  end

  def upload
    if request.post?
      handle_file_upload
    else
      render :upload
    end
  end

  def download
    filename = params[:filename]
    file_path = File.join(Rails.root, 'tmp', filename)

    if filename && File.exist?(file_path)
      send_file(
        file_path,
        filename: filename,
        type: 'application/octet-stream'
      )
    else
      flash[:error] = 'File not found'
      redirect_to action: 'upload'
    end
  end

  private

  def handle_file_upload
    if params[:file]
      save_uploaded_file
      flash[:notice] = 'File uploaded successfully'
    else
      flash[:error] = 'No file selected'
    end
    redirect_to action: 'upload'
  end

  def save_uploaded_file
    uploaded_file = params[:file]
    original_filename = uploaded_file.original_filename
    file_path = File.join(Rails.root, 'tmp', original_filename)
    
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_file.read)
    end
  end
end

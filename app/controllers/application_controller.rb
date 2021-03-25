class ApplicationController < ActionController::Base
  before_action :require_basic_auth

  private

  def require_basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.basic_auth[:username] &&
        password == Rails.application.credentials.basic_auth[:password]
    end
  end
end

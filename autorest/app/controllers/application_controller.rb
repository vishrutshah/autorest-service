class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  attr_accessor :swagger_url
end

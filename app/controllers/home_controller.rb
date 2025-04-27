# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :forbid_login_user, only: [:index]

  def index
  end
end

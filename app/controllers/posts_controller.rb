# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    render plain: "Hello from Posts#index"
  end

  def select
  end

  def monthselect
    year = params[:year]
    month = params[:month]
    redirect_to theaccounting_path(year: year, month: month)
  end
end

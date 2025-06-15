# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    render plain: "Hello from Posts#index"
  end
end

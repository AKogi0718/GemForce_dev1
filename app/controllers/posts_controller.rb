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
  def theaccounting
    @year = params[:year]
    @month = params[:month]

    # 外部DB（prosper）からのデータ取得
    @posts = ProsperPost.where("EXTRACT(YEAR FROM date) = ? AND EXTRACT(MONTH FROM date) = ?", @year, @month)
    @comp = ProsperCorporation.all
    @urikake1 = ProsperUrikake.where(process: 1)
    @urikake2 = ProsperUrikake.where(process: 2)
    @pastprice = ProsperPost.where(process: 3)
    @nowprice = ProsperPost.where(process: 4)
    @pastallnyukin = ProsperPost.where(process: 5)
    @nowallnyukin = ProsperPost.where(process: 6)
    @pastallsousai = ProsperPost.where(process: 7)
    @nowsousai = ProsperPost.where(process: 8)

    render 'theaccounting'
  end

end

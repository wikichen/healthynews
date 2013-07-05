class PagesController < ApplicationController
  def index
    @posts = find_posts_with_order(false)

    #@posts = Post.order('hotness')
    #             .paginate(page: params[:page])
    #             .per_page(20)

    respond_to do |format|
      format.html { render :action => "index" }
      format.json { render json: @posts }
    end
  end

  def about
  end

private
  def find_posts_with_order(newest = false)
    conds = []

    posts = Post.find(
      :all,
      :conditions => conds,
      :order => (newest ? "posts.created_at DESC" : "hotness")
    )

    posts
  end
end

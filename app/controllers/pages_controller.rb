class PagesController < ApplicationController
  POSTS_PER_PAGE = 20


  def index
    @posts = find_posts_for_newest(false)

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

  def newest
    @posts = find_posts_for_newest(true)
    respond_to do |format|
      format.html { render :action => "newest" }
      format.json { render json: @posts }
    end
  end

private
  def find_posts_for_newest(newest = false)
    @page = 1
    if params[:page].to_i > 0
      @page = params[:page].to_i
    end

    # TODO: caching for guest views

    posts, @show_more = _find_posts_for_newest(newest)

    posts
  end


  def _find_posts_for_newest(newest = false)
    conds = []

    posts = Post.find(
      :all,
      :conditions => conds,
      :limit => POSTS_PER_PAGE + 1,
      :offset => (@page - 1) * POSTS_PER_PAGE,
      :order => (newest ? "posts.created_at DESC" : "hotness")
    )

    show_more = false

    if posts.count > POSTS_PER_PAGE
      show_more = true
      posts.pop
    end

    # TODO: eager load comment counts

    [ posts, show_more ]
  end
end

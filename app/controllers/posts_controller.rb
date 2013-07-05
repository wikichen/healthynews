class PostsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('created_at DESC')
                 .paginate(page: params[:page])
                 .per_page(20)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.user ||= current_user
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user ||= current_user

    if @post.save
      Vote.vote_thusly_on_post_or_comment_for_user_because(1, @post.id, nil, current_user.id, nil)

      flash[:success] = "Your post has been submitted successfully."

      redirect_to @post
    else
      return render action: "new"
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.user != current_user
        format.html { redirect_to @post, notice: "You can't edit this post." }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      elsif @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    if @post.user != current_user
      flash[:notice] = "You can't delete this post."

      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    else
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end
    end
  end

  def upvote
    if !(post = Post.find_by_short_id(params[:post_id]))
      return render :text => "Can't find story", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(1, post.id,
      nil, current_user.id, nil)

    render :text => "ok"
  end

end

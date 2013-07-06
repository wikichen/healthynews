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
    @post = Post.find_by_short_id!(params[:id])

    @short_url = @post.short_id_url

    @comments = Comment.ordered_for_post_or_thread_for_user(@post.id, nil,
                                                            current_user)

    respond_to do |format|
      format.html {
        @comment = Comment.new

        render :action => "show"
      }
      format.json {
        render :json => @post.as_json(:with_comments => @comments)
      }
    end

  end

  def show_comment
    @post = Post.find_by_short_id!(params[:id])

    @title = @post.title

    @showing_comment = Comment.find_by_short_id(params[:comment_short_id])

    if !@showing_comment
      flash[:error] = "Comment does not exist."
      return redirect_to @post.comments_url
    end

    # TODO: fix not showing -> something to do with the thread_id not updating
    @comments = Comment.ordered_for_post_or_thread_for_user(@post.id,
                                              @showing_comment.thread_id,
                                              current_user ? current_user : nil)

    @comments.each do |c, x|
      if c.id = @showing_comment.id
        c.highlighted = true
        break
      end
    end

    @comment = Comment.new

    render :action => "show"
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

      redirect_to @post.comments_url
    else
      return render action: "new"
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update



    return redirect_to @post.comments_url

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
      return render :text => "Can't find post", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(1, post.id,
      nil, current_user.id, nil)

    render :text => "ok"
  end

  def downvote
    if !(story = Post.find_by_short_id(params[:story_id]))
      return render :text => "can't find story", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(-1, post.id,
      nil, current_user.id, params[:reason])

    render :text => "ok"
  end

  def unvote
    if !(post = post.find_by_short_id(params[:post_id]))
      return render :text => "can't find post", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(0, post.id,
      nil, current_user.id, nil)

    render :text => "ok"
  end

end

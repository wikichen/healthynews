class CommentsController < ApplicationController
  before_filter :authenticate_user!,
    :only => [:create, :upvote, :downvote, :unvote]

  def create
    # TODO: make sure post exists
    if !(post = Post.find_by_short_id(params[:post_id]))
      return render :text => "can't find story", :status => 400
    end

    comment = Comment.new
    comment.comment = params[:comment].to_s
    comment.post_id = post.id
    comment.user_id = current_user.id

    if params[:parent_comment_short_id].present?
      if pc = Comment.find_by_post_id_and_short_id(post.id,
                                             params[:parent_comment_short_id])
        comment.parent_comment_id = pc.id
        comment.parent_comment_short_id = pc.short_id
        comment.thread_id = pc.thread_id
      else
        return render :json => { :error => "invalid parent comment",
                                 :status => 400 }
      end
    else
      #comment.thread_id = Keystore.incremented_value_for("thread_id")
    end

    # TODO: prevent double clicking post button

    if comment.valid? && comment.save
      comment.current_vote = { :vote => 1 }

      if comment.parent_comment_id
        render :partial => "postedreply", :layout => false,
                                          :content_type => "text/html",
                                          :locals => { :post => post,
                                                       :show_comment => comment }
      else
        render :partial => "commentbox", :layout => false,
                                         :content_type => "text/html",
                                         :locals => { :post => post,
                                                      :comment => Comment.new,
                                                      :show_comment => comment }
      end
    else
      comment.upvotes = 1
      comment.current_vote = { :vote => 1}

      render :partial => "commentbox", :layout => false,
                                       :content_type => "text/html",
                                       :locals => { :post => post,
                                                    :comment => comment,
                                                    :show_comment => comment }
    end
  end

  def upvote
    if !(comment = Comment.find_by_short_id(params[:comment_id]))
      return render :text => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(1, comment.post_id,
      comment.id, current_user.id, nil)

    render :text => "ok"
  end

  def downvote
    if !(comment = Comment.find_by_short_id(params[:comment_id]))
      return render :text => "can't find comment", :status => 400
    end

    if !Vote::COMMENT_REASONS[params[:reason]]
      return render :text => "invalid reason", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(-1, comment.post_id,
      comment.id, current_user.id, nil)

    render :text => "ok"
  end

  def unvote
    if !(comment = Comment.find_by_short_id(params[:comment_id]))
      return render :text => "can't find comment", :status => 400
    end

    Vote.vote_thusly_on_post_or_comment_for_user_because(0, comment.post_id,
      comment.id, current_user.id, nil)

    render :text => "ok"
  end

end

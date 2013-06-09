class CommentsController < ApplicationController
  def show

  end

  def new
    @link = Link.new
  end

  def create
    @comment = Comment.create(params[:comment])
    redirect_to :back
  end
end

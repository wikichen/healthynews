class VotesController < ApplicationController
  before_filter :authenticate_user!

  #def create
  #  @vote = current_user.votes.where(:post_id => params[:vote][:post_id]).first
  #  @vote ||= current_user.votes.create(params[:vote])
  #  @vote.update_attributes(:vote => params[:vote][:vote])
  #  redirect_to :back
  #end
end

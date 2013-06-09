class VotesController < ApplicationController
  def create
    @vote = current_user.votes.create(params[:vote])
    redirect_to :back
  end
end

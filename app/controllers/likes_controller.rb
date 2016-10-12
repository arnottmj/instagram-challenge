class LikesController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def create 
    @picture = Picture.find(params[:picture_id])
    @like = @picture.likes.build(user: current_user)

    if @like.save
      redirect_to pictures_path
    else
      if @like.errors[:user]
        flash[:notice] = 'You have already liked this picture'
        redirect_to pictures_path
      else
        render :new
      end
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @picture = Picture.find(params[:picture_id])

    if current_user_has_liked?(@like)
      @like.destroy
      flash[:notice] = "You have unliked \'#{@picture.name}\'"
      redirect_to '/pictures'
    else
      flash[:notice] = "You have not liked the picture \'#{@picture.name}\'"
      redirect_to '/pictures'
    end
  end

  private

  def current_user_has_liked?(like)
    if !user_signed_in?
      return false
    else
      current_user.likes.include?(like)
    end
  end
end

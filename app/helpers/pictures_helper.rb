module PicturesHelper

  def current_user_has_picture_ownership?(picture)
    if !user_signed_in?
      return false
    else
      current_user.id == picture.user.id
    end
  end

  def current_user_has_comment_ownership?(comment)
    if !user_signed_in?
      return false
    else
      current_user.id == comment.user.id
    end
  end

  def already_liked?(picture)
    if !user_signed_in?
      return false
    else
      !retrieve_user_picture_like(picture).nil?
    end
  end

  def retrieve_user_picture_like(picture)
    picture.likes.find_by(user_id: current_user.id)
  end

end

module PicturesHelper

  def validate_picture_ownership(picture)
    if !user_signed_in?
      return false
    else
      current_user.id == picture.user.id
    end
  end

  def already_liked?(picture)
    if !user_signed_in?
      return false
    else
      !picture.likes.find_by(user_id: current_user.id).nil?
    end
  end

  def retrieve_user_picture_like(picture)
    picture.likes.find_by(user_id: current_user.id)
  end

end

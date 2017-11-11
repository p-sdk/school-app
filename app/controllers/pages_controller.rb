class PagesController < ApplicationController
  expose(:courses, from: :current_user)
  expose(:teacher_courses, from: :current_user)

  skip_before_action :authenticate_user!

  def home
    skip_authorization
    return unless user_signed_in?
    render 'dashboard'
  end
end

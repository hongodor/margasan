class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all
    if current_user.admin?
      render 'users/index'
    else
      render 'users/list'
    end
  end
end
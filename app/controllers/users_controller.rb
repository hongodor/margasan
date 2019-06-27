class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    @users = User.all
    if current_user.admin?
      render 'users/index'
    else
      render 'users/list'
    end
  end

  def show
    @user = User.includes(:projects, :options).find(params[:id])
  end

end
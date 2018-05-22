class OptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    option = current_user.options.new(option_params)
    option.phrase_id = params[:phrase_id]
    if option.save
      render json: option
    else
      render json: { errors: option.errors.messages }, status: 422
    end
  end

  def destroy
    option = Option.find(params[:id])
    option.destroy
  end

  private
  def option_params
    params.require(:option).permit(:content, :check)
  end
end

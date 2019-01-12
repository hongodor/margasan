class OptionsController < ApplicationController
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :json_user_not_authorized

  def create
    @option = current_user.options.new(option_params)
    @option.phrase_id = params[:phrase_id]
    @option.author = current_user.username
    @option.save
    if @option.save
      head 200
    else
      render json: { errors: option.errors.messages }, status: 422
    end
  end

  def update
    @option = Option.find(params[:id])
    authorize @option
    if @option.update(option_params)
      render json: @option
    else
      render json: { errors: @option.errors.full_messages }
    end
  end

  def destroy
    @option = Option.find(params[:id])
    authorize @option
    @option.destroy
  end

  private
  def option_params
    params.require(:option).permit(:content, :check, :phrase_id)
  end
end

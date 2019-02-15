class PhrasesController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  rescue_from Pundit::NotAuthorizedError, with: :json_user_not_authorized

  def update
    @phrase = Phrase.find(params[:id])
    @option = Option.find(phrase_params[:option_id])
    authorize @phrase
    @phrase.translated = @option.content
    @phrase.check = true
    if @phrase.save
      render json: @option
    else
      render json: { errors: @phrase.errors.full_messages }
    end
  end

  private

  def phrase_params
    params.require(:phrase).permit(:option_id)
  end
end

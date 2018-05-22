class PhrasesController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  rescue_from Pundit::NotAuthorizedError, with: :json_user_not_authorized

  def update
    phrase = Phrase.find(params[:phrase_id])
    option = Option.find(params[:option_id])
    phrase.translated = option.content

    authorize phrase
    if phrase.save
      render json: option
    else
      render json: { errors: phrase.errors.full_messages }
    end
  end

  def json_user_not_authorized
    head 403
  end

  private

  def phrase_params
    params.require(:phrase).permit(:option_id)
  end
end

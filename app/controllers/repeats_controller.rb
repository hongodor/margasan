class RepeatsController < ApplicationController

  def create
    @repeat = Repeat.new(repeat_params)
    if @repeat.save
      render json: @repeat
    else
      render json: { errors: @repeat.errors.full_messages }
    end
  end

  def destroy
    @repeat = Repeat.find(params[:id])
    @repeat.destroy
    head 200
  end
  private

  def repeat_params
    params.require(:repeat).permit(:phrase, :translation, :project_id)
  end
end

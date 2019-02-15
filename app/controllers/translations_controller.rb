class TranslationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chapter

  def create
    #authorize @chapter
    TranslatePhrasesJob.perform_now(@chapter)
    redirect_back fallback_location: @chapter.project
  end

  def find_equal

  end
  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end
end

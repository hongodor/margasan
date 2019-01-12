class TranslationsController < ApplicationController
  before_action :set_chapter

  def create
    TranslatePhrasesJob.perform_now(@chapter)
    redirect_to(@chapter.project)
  end


  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end
end

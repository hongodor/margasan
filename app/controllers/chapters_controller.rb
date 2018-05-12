class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :destroy]

  def show

  end

  def create
    @chapter = Chapter.new(chapter_params)
    if @chapter.save
      flash[:success] = "Chapter was successfully created"
      redirect_to @chapter
    else
      render 'show'
    end
  end

  def destroy

  end

  private
  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def chapter_params
    params.require(:chapter).permit(:name, :status, :chapter_file)
  end
end

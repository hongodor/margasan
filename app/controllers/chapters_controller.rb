class ChaptersController < ApplicationController
  before_action :set_chapter, only: [:show, :destroy]
  before_action :authenticate_user!, except: [:show]

  def show

  end

  def create
    @chapter = current_user.chapters.new(chapter_params)
    @chapter.project_id = params[:project_id]
    @chapter.filename = @chapter.chapter_file.filename
    if @chapter.save
      flash[:success] = "Chapter was successfully created"
      redirect_to @chapter
    else
      flash[:error] = "Fail"
      @chapter.chapter_file.purge
      redirect_to @chapter.project
    end
  end

  def destroy
    @chapter.chapter_file.purge
    @chapter.destroy
    flash[:alert] = "Chapter was successfully deleted"
    redirect_to @chapter.project
  end

  private
  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def chapter_params
    params.require(:chapter).permit(:name, :chapter_file)
  end
end

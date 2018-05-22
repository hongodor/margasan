class ChaptersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @chapter = Chapter.includes(phrases: :options).find(params[:id])
  end

  def create
    @chapter = current_user.chapters.new(chapter_params)
    @chapter.project_id = params[:project_id]
    @chapter.filename = @chapter.chapter_file.filename
    authorize @chapter
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
    @chapter = Chapter.find(params[:id])
    authorize @chapter
    @chapter.chapter_file.purge
    @chapter.destroy
    flash[:success] = "Chapter was successfully deleted"
    redirect_to @chapter.project
  end

  private

  def chapter_params
    params.require(:chapter).permit(:name, :chapter_file)
  end
end

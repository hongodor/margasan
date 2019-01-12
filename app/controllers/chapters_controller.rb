class ChaptersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @chapter = Chapter.includes(phrases: :options).find(params[:id])
  end

  def create
    project = Project.find(params[:project_id])
    # TODO Policy
    authorize project, :update?, policy_class: ProjectPolicy
    chapter_params['chapter_file'].each do |file|
      chapter = Chapter.new(name: file.original_filename, project: project, user: current_user, filename: file.original_filename)
      chapter.chapter_file.attach(file)
      if chapter.save
        CreatePhrasesJob.perform_now(chapter)
        flash[:success] = "Chapters was successfully created"
        redirect_to project
      else
        chapter.chapter_file.purge
        flash[:error] = "Fail"
        redirect_to project
      end
    end

  end

  def generate
    TranslatePhrasesJob.perform_now(chapter)
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    authorize @chapter
    @chapter.destroy
    flash[:success] = "Chapter was successfully deleted"
    redirect_to @chapter.project
  end

  private

  def chapter_params
    params.require(:chapter).permit( chapter_file:[])
  end
end

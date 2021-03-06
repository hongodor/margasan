class ChaptersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @chapter = Chapter.includes(phrases: :options).find(params[:id]).as_json(include: { phrases: { include: :options}})
  end

  def create
    project = Project.find(params[:project_id])
    authorize project, :update?, policy_class: ProjectPolicy
    chapter_params['chapter_file'].each do |file|
      if file.original_filename =~ /Map\d*.json/
          chapter = Chapter.new(name: file.original_filename, project: project, user: current_user, filename: file.original_filename)
          chapter.chapter_file.attach(file)
          if chapter.save
            CreatePhrasesJob.perform_now(chapter)
          else
            chapter.chapter_file.purge
          end
      end
    end
    redirect_back fallback_location: project
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

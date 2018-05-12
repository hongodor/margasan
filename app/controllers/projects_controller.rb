class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @projects = Project.all
  end

  def show
    @chapters = @project.chapters
    @chapter = Chapter.new
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      flash[:success] = "Project was succesfully created!"
      redirect_to @project
    else
      flash[:error] = "Something went wrong!"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:success] = "Project was successfully updated!"
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    flash[:success] = "Project was successfully destroyed."
    redirect_to projects_url
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :author)
  end
end

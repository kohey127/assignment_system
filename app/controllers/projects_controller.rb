class ProjectsController < ApplicationController
  before_action :authenticate_manager!
  
  def index
    @projects = Projects.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "案件を作成しました。"
      redirect_to projects_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
  def project_params
    params.require(:project).permit(:name, :information, :scheduled_start_date, :scheduled_finish_date, :status)
  end
end

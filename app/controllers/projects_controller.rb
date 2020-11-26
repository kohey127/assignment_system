class ProjectsController < ApplicationController
  
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.status = "preparation"
    if @project.save
      flash[:success] = "案件を新規に作成しました。"
      redirect_to projects_path
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:success] = "案件の情報を更新しました。"
      redirect_to project_path(@project.id)
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      flash[:success] = "案件を削除しました。"
      redirect_to projects_path
    else
      render :edit
    end
  end
  
  private
  def project_params
    params.require(:project).permit(:name, :information, :scheduled_start_date, :scheduled_finish_date, :status)
  end
end

class CommitsController < ApplicationController
  before_action :authenticate_manager!
  
  def index
    @employees = Employee.only_active
    if params[:target_year].present?
      @target_year = params[:target_year]
    end
  end

  def show
    @year = params[:target_year]
    @month = params[:id]
    target_month_start_time = month_start_time(@year, @month).in_time_zone
    target_month_finish_time = next_month_start_time(@year, @month).in_time_zone - 1
    # 「対象月の終わりよりも、開始予定日が前である」かつ「対象月の始まりよりも、終了予定日が後である」案件を取得
    @projects = Project.where("scheduled_start_date <= ? AND ? <= scheduled_finish_date", target_month_finish_time, target_month_start_time)
    @employees = Employee.only_active
  end

  def new
    @project = Project.find(params[:target_project])
    target_month = make_target_month(params[:target_month], params[:target_year])
    @commit = Commit.find_or_initialize_by(project_id: @project.id, target_month: target_month)
    if @commit.persisted?
      @commits = Commit.where(project_id: params[:target_project], target_month: target_month)
    end
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  
  def make_target_month(month, year)
    month = month.to_s
    year = year.to_s
    if month.length == 1
      month= "0#{month}"
    end
    year + month
  end
  
  def month_start_time(year, month)
    month = month.to_s
    year = year.to_s
    if month.length == 1
      month = "0" + month
    end
    "#{year}-#{month}-01"
  end
  
  def next_month_start_time(year, month)
    month = month.to_s
    year = (year.to_i + 1).to_s
    if month.length == 1
      month = "0" + month
    end
    "#{year}-#{month}-01"
  end
  
end

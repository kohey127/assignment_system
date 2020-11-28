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
    # target_month_start_time = month_start_time(@year, @month).in_time_zone
    # target_month_finish_time = next_month_start_time(@year, @month).in_time_zone - 1
    # # 「対象月の終わりよりも、開始予定日が前である」かつ「対象月の始まりよりも、終了予定日が後である」案件を取得
    # @projects = Project.only_active.where("scheduled_start_date <= ? AND scheduled_finish_date >= ?", target_month_finish_time, target_month_start_time)
    
    @employees = Employee.only_active
    @projects = target_projects(@year, @month)
  end

  def new
    @project = Project.find(params[:target_project])
    @year = params[:target_year]
    @month = params[:target_month]
    @target_month = make_target_month(@year, @month)
    @commit = Commit.new
    @term = (@project.scheduled_start_date..@project.scheduled_finish_date).to_a.map {|a| a.strftime("%Y/%m")}.uniq
  end

  def create
    # 手動バリデーション
    error_flag = 0
    if params[:target_param].blank?
      flash[:danger] = "対象期間を選択してください"
      error_flag = 1
    end
    
    if params[:employee_id].blank?
      flash[:danger] = "社員名を選択してください"
      error_flag = 1
    end
    
    binding.pry
    
    if params[:commit_rate].blank? || params[:commit_rate].to_i < 0 || params[:commit_rate].to_i > 100
      flash[:danger] = "稼働率は0～100の範囲で正しく入力してください"
      error_flag = 1
    end
    
    if error_flag == 1
      redirect_to request.referer and return
    end
    
    case params[:target_param]
    when "0"
      commit = Commit.new
      commit.employee_id = params[:employee_id]
      commit.project_id = params[:project_id]
      commit.commit_rate = params[:commit_rate]
      commit.target_month = params[:target_month]
    binding.pry
      commit.save
    when "1"
      target_months = params[:target_months].split
      target_months.count.times do |i|
        commit = Commit.new
        commit.employee_id = params[:employee_id]
        commit.project_id = params[:project_id]
        commit.commit_rate = params[:commit_rate]
        commit.target_month = target_months[i].delete("/")
        commit.save!
      end
    end
    redirect_to request.referer
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  # Commitのcommit_rateカラムに保存できる形のtarget_monthを生成する
  def make_target_month(year, month)
    year = year.to_s
    month = month.to_s
    if month.length == 1
      month= "0#{month}"
    end
    year + month
  end
  
  # def month_start_time(year, month)
  #   year = year.to_s
  #   month = month.to_s
  #   if month.length == 1
  #     month = "0" + month
  #   end
  #   "#{year}-#{month}-01"
  # end
  
  # def next_month_start_time(year, month)
  #   year = year.to_s
  #   month = (month.to_i + 1).to_s
  #   if month.length == 1
  #     month = "0" + month
  #   end
  #   "#{year}-#{month}-01"
  # end
  
  # 対象期間に含まれるプロジェクトを取得する
  def target_projects(year, month)
    projects = Project.only_active
    # 対象の月
    target_month = make_target_month(year, month)
    # 取得した案件を格納する配列を作成する
    ids = []
    projects.each do |project|
      # 案件の開始予定日と終了予定日の範囲に含まれる配列を取得する
      terms = (project.scheduled_start_date..project.scheduled_finish_date).to_a.map {|a| a.strftime("%Y/%m")}.uniq
      # target_monthとtermsが一致した案件をresultに格納する
      terms.count.times do |i|
        if terms[i].delete("/") == target_month
          ids << project.id
        end
      end
    end
    Project.where(id: ids)
  end
  
end

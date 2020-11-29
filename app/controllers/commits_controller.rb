class CommitsController < ApplicationController
  before_action :authenticate_manager!
  
  def index
    @employees = Employee.only_active
    if params[:target_year].present?
      @target_year = params[:target_year]
    else
      @target_year = (Date.today << 3).year
    end
    # ビューで使用する月データ
    @month = [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3]
    
    # グラフ作成
    # 最終的に表示するグラフの配列を定義
    @target_months = []
    # グラフの横軸を作成するために年度月の配列を定義
    months = ["04", "05", "06", "07", "08", "09", "10", "11", "12", "01", "02", "03"]
    # 年度表示するため、4~12月と、1~3月で処理を分岐
    # 4~12月
    9.times do |i|
      @target_months << @target_year.to_s + months[i]
    end
    # 1~3月
    3.times do |i|
      @target_months << (@target_year.to_i + 1).to_s + months[i + 9]
    end
    # プロジェクト、社員、対象月の3キーを主キーとする(重複なし)、作成日が最新の稼働率を取得(Commitモデルに定義したスコープで最新が取れる)
    commits = Commit.group(:project_id, :employee_id, :target_month)
    # グラフデータを格納する配列を定義
    @graph_data = []
    # グラフの横軸の月数(YYYYMM)の配列を回す
    @target_months.each do |month|
      # 稼働率の合計値を格納する変数を定義
      total = 0
      # 横軸の月名と一致するデータを回し、稼働率を合計
      commits.where(target_month: month).each do |commit|
        # その中で、社員が有効かつ、案件が事前調整中か進行中かつ、稼働率の対象月が案件の予定期間に含まれている(案件の期間を変更されていない)のものを取得
        if commit.employee.is_active == true && (commit.project.status == "preparation" || commit.project.status == "ongoing") && commit.project.include_target_months.include?(month) 
          total += commit.commit_rate
        end
      end
      # 取得したデータをグラフ用に整形
      month = month.slice(2, 4).insert(2, "年") << "月"
      total = (total / 100.to_f).round(2)
      total = ((Employee.only_active.count) - total).round(2)
      # データを配列に格納
      @graph_data << [month, total]
    end
  end

  def show
    @year = params[:target_year]
    @month = params[:id]
    @employees = Employee.only_active
    @projects = target_projects(@year, @month)
  end

  def new
    @project = Project.find(params[:target_project])
    @year = params[:target_year]
    @month = params[:target_month]
    @target_month = make_target_month(@year, @month)
    @commit = Commit.new
    # プロジェクトの開始予定日と完了予定日の間に該当する月名(YYYYMM)を重複なく取得
    @term = (@project.scheduled_start_date..@project.scheduled_finish_date).to_a.map {|a| a.strftime("%Y/%m")}.uniq
  end

  def create
    # 手動バリデーション（テーブル名CommitがSQLの予約語でありバリデーション使えないため、暫定処置）
    error_flag = 0
    if params[:target_param].blank?
      flash[:danger] = "対象期間を選択してください"
      error_flag = 1
    end
    
    if params[:employee_id].blank?
      flash[:danger] = "社員名を選択してください"
      error_flag = 1
    end
    
    if params[:commit_rate].blank? || params[:commit_rate].to_i < 0 || params[:commit_rate].to_i > 100
      flash[:danger] = "稼働率は0～100の範囲で正しく入力してください"
      error_flag = 1
    end
    
    if error_flag == 1
      redirect_to request.referer and return
    end
    # 稼働率作成処理ここから
    case params[:target_param]
    # この月だけ追加するとき
    when "this_month"
      commit = Commit.new
      commit.employee_id = params[:employee_id]
      commit.project_id = params[:project_id]
      commit.commit_rate = params[:commit_rate]
      commit.target_month = params[:target_month]
      commit.save
    # 全期間に追加するとき
    when "all_month"
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
  
  # 対象期間に含まれるプロジェクトを取得する
  def target_projects(year, month)
    projects = Project.only_active
    # 対象の月
    target_month = make_target_month(year, month)
    # 取得した案件を格納する配列を作成する
    ids = []
    projects.each do |project|
      # 案件の開始予定日と終了予定日の範囲に含まれる配列を取得する
      terms = (project.scheduled_start_date..project.scheduled_finish_date).to_a.map {|a| a.strftime("%Y%m")}.uniq
      # target_monthとtermsが一致した案件をresultに格納する
      terms.count.times do |i|
        if terms[i] == target_month
          ids << project.id
        end
      end
    end
    Project.where(id: ids)
  end
  
end

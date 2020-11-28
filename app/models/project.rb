class Project < ApplicationRecord
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :scheduled_start_date, presence: true
  validates :scheduled_finish_date, presence: true
  
  enum status:{ preparation: 0, failure: 1, ongoing: 2, done: 3 }
  validates :status, presence: true
  
  # ステータスが「事前調整中」および「進行中」の案件を取得
  scope :only_active, -> { where(status: "preparation").or(Project.where(status: "ongoing")) }
  
  # すでにこの案得件を担当している社員を重複なく取得する
  def already_commits(target_month)
    self.commits.where(target_month: target_month).group(:employee_id)
  end
  
  # 対象期間に含まれるプロジェクトを取得する
  def target_projects(year, month)
    self.each do |project|
      # 対象の月
      target_month = make_target_month(year, month)
      # 案件の開始予定日と終了予定日の範囲に含まれる配列を取得する
      terms = (project.scheduled_start_date..project.scheduled_finish_date).to_a.map {|a| a.strftime("%Y/%m")}.uniq
      # 取得した案件を格納する配列を作成する
      ids = []
      # target_monthとtermsが一致した案件をresultに格納する
      terms.count.times do |i|
        if terms[i].delete("/") == target_month
          ids << project.id
        end
      end
    end
    Project.where(id: ids)
  end
  
  def make_target_month(year, month)
    year = year.to_s
    month = month.to_s
    if month.length == 1
      month= "0#{month}"
    end
    year + month
  end
end

class Project < ApplicationRecord
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :scheduled_start_date, presence: true
  validates :scheduled_finish_date, presence: true
  
  enum status:{ preparation: 0, failure: 1, ongoing: 2, done: 3 }
  validates :status, presence: true
  
  # ステータスが「事前調整中」および「進行中」の案件を取得
  scope :only_active, -> { where(status: "preparation").or(Project.where(status: "ongoing")) }
  
  # すでにこの案件を担当している有効社員(の稼働率)を重複なく取得する
  def already_commits(target_month)
    self.commits.where(target_month: target_month).group(:employee_id)
  end
  
  def include_target_months
    (self.scheduled_start_date..self.scheduled_finish_date).to_a.map {|a| a.strftime("%Y%m")}.uniq
  end
  
  # 対象月をYYYYMMの形で生成する
  def make_target_month(year, month)
    year = year.to_s
    month = month.to_s
    if month.length == 1
      month= "0#{month}"
    end
    year + month
  end
end

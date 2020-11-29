class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :grade
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :employee_id, presence: true, uniqueness: true
  
  scope :only_active, -> { where(is_active: true) }
  
  def how_commit_sum(i, year)
    i = i.to_s
    year = year.to_s
    if i.length == 1
      i = "0#{i}"
    end
    
    target = year + i
    # 合計稼働率を取得するための変数を定義
    total = 0
    # 社員情報と対象月の組み合わせのデータがCommitテーブルに存在するとき
    if Commit.where(employee_id: self.id, target_month: target).present?
      # Commitテーブルから社員の各プロジェクトの最新データを取得(commitモデルのスコープにより最新データが取得できる)
      Commit.where(employee_id: self.id, target_month: target).group(:project_id).each do |commit|
        # その中で、案件が事前調整中、進行中のものを取得し、稼働率を合計
        if commit.project.status == "preparation" || commit.project.status == "ongoing"
          total += commit.commit_rate
        end
      end
      total
    else
      "-"
    end
  end
  
  # 年、月、プロジェクト、社員の組み合わせで、すでに登録されている稼働率をする
  def how_commit_detail(year, month, project)
    month = month.to_s
    year = year.to_s
    if month.length == 1
      month= "0#{month}"
    end
    
    target = year + month
    
    if Commit.find_by(employee_id: self.id, target_month: target, project_id: project.id).present?
      Commit.find_by(employee_id: self.id, target_month: target, project_id: project.id).commit_rate
    else
      "-"
    end
    
  end
end

class Project < ApplicationRecord
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :scheduled_start_date, presence: true
  validates :scheduled_finish_date, presence: true
  
  enum status:{ preparation: 0, failure: 1, ongoing: 2, done: 3 }
  validates :status, presence: true
  
  # ステータスが「事前調整中」および「進行中」の案件を取得
  scope :only_active, -> { where(status: "preparation").or(Project.where(status: "ongoing")) }
  
end

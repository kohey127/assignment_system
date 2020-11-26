class Project < ApplicationRecord
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :scheduled_start_date, presence: true
  validates :scheduled_finish_date, presence: true
  
  enum status:{ preparation: 0, failure: 1, ongoing: 2, done: 3 }
  validates :status, presence: true
  
end

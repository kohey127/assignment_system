class Commit < ApplicationRecord
  belongs_to :employee
  belongs_to :project
  
  validates :target_month, presence: true
  validates :commit_rate, presence: true
end

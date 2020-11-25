class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :grade
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :employee_id, presence: true
  validates :is_active, presence: true
end

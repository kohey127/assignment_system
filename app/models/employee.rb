class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :grade
  has_many :commits, dependent: :destroy
end

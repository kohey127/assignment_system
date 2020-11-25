class Grade < ApplicationRecord
  has_many :employees, dependent: :destroy
end

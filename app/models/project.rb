class Project < ApplicationRecord
  has_many :commits, dependent: :destroy
end

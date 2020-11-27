class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :grade
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :employee_id, presence: true, uniqueness: true
  
  scope :only_active, -> { where(is_active: true) }
  
  def how_commit(i, year)
    i = i.to_s
    year = year.to_s
    if i.length == 1
      i = "0#{i}"
    end
    
    target = year + i
    
    if Commit.where(employee_id: self.id, target_month: target).present?
      Commit.where(employee_id: self.id, target_month: target).pluck(:commit_rate).sum
    else
      "-"
    end
  end
  
  def how_commit_detail(year, month, project)
    month = month.to_s
    year = year.to_s
    if month.length == 1
      month= "0#{month}"
    end
    
    target = year + month
    
    if Commit.where(employee_id: self.id, target_month: target, project_id: project.id).present?
      Commit.where(employee_id: self.id, target_month: target, project_id: project.id).commit_rate
    else
      "-"
    end
    
  end
end

class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :grade
  has_many :commits, dependent: :destroy
  
  validates :name, presence: true
  validates :employee_id, presence: true, uniqueness: true
  
  def how_commit(i)
    if i < 9
      i += 4 
    else
      i -= 8
    end
    
    i = i.to_s
    if i.length == 1
      i = "0" + "i"
    end
    
    target = Date.today.strftime("%Y") + i
    
    if Commit.where(employee_id: self.id, target_month: target).present?
      Commit.where(employee_id: self.id, target_month: target).rate
    else
      "-"
    end
  end
end

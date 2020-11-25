class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.integer :department_id, null: false
      t.integer :grade_id, null: false
      t.string :name, null: false
      t.string :employee_id, null: false
      t.text :information
      t.boolean	:is_active, null: false, default: true
      
      t.timestamps
    end
  end
end

class CreateCommits < ActiveRecord::Migration[6.0]
  def change
    create_table :commits do |t|
      t.integer :employee_id, null: false
      t.integer :project_id, null: false
      t.string :target_month, null: false
      t.integer :commit_rate, null: false

      t.timestamps
      
      add_index :commits, [ :employee_id, :project_id, :target_month ], unique: true
    end
  end
end

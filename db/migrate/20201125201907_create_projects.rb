class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :information
      t.date :scheduled_start_date, null: false
      t.date :scheduled_finish_date, null: false
      t.integer	:status, null: false

      t.timestamps
    end
  end
end

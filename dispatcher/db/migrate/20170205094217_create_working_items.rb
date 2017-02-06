class CreateWorkingItems < ActiveRecord::Migration[5.0]
  def change
    create_table :working_items do |t|
      t.string :work_type
      t.string :content
      t.integer :version
      t.integer :status

      t.timestamps
    end
  end
end

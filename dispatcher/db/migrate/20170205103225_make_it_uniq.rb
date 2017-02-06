class MakeItUniq < ActiveRecord::Migration[5.0]
  def change
    add_index :working_items, [:work_type, :content, :version], :unique => true
  end
end

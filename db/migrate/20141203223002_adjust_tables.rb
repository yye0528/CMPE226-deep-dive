class AdjustTables < ActiveRecord::Migration
  def change
    add_column :comments, :post_id, :integer
    change_column :comments, :content, :text
  end
end

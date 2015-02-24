class AddIndex < ActiveRecord::Migration
  def change
    add_index :posts, [:jobtitle, :company], unique: true
  end
end

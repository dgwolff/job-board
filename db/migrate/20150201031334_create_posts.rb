class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :jobtitle
      t.string :company
      t.string :city
      t.string :state
      t.string :formatted_location
      t.string :date
      t.string :snippet
      t.string :url
      t.string :jobkey

      t.timestamps null: false
    end
  end
end

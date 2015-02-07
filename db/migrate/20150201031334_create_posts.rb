class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :jobtitle
      t.string :company
      t.string :city
      t.string :state
      t.string :location
      t.string :remote
      t.datetime :date
      t.string :summary
      t.string :url
      t.string :jobkey

      t.timestamps null: false
    end
  end
end

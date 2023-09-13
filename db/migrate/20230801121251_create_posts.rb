class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :rice_name
      t.string :rice_from
      t.string :rice_flavor
      t.text :about

      t.timestamps
    end
  end
end

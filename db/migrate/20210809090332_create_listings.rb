class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.string :name
      t.text :description
      t.float :price
      t.boolean :available
      t.references :user, null: false, foreign_key: true
      t.string :category

      t.timestamps
    end
  end
end

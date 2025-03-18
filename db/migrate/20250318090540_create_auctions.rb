class CreateAuctions < ActiveRecord::Migration[8.0]
  def change
    create_table :auctions do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :starting_price, null: false
      t.decimal :current_price
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.string :status
      t.references :seller, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

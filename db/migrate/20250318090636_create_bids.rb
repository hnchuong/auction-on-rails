class CreateBids < ActiveRecord::Migration[8.0]
  def change
    create_table :bids do |t|
      t.decimal :amount
      t.string :status, null: false, default: "BIDDING"
      t.references :auction, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

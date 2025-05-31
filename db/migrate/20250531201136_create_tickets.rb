class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :from
      t.string :to
      t.float :price
      t.string :date
      t.integer :user_id
      t.integer :discount
      t.float :lightning

      t.timestamps
    end
  end
end

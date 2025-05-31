class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :ticket_id
      t.integer :user_id

      t.timestamps
    end
  end
end

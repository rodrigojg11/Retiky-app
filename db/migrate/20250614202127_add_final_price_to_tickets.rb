class AddFinalPriceToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :final_price, :float
  end
end

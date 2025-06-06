class AddLightningStartTimeToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :lightning_start_time, :datetime
  end
end

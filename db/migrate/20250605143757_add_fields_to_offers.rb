class AddFieldsToOffers < ActiveRecord::Migration[7.1]
  def change
    add_column :offers, :origin, :string
    add_column :offers, :destination, :string
    add_column :offers, :departure_date, :date
  end
end

class OrdersController < ApplicationController

  def create
    @order = Order.create(user_id: current_user.id, ticket_id: params[:ticket_id])
    redirect_to orders_path(@order), notice: "Your order was placed successfully!"
  end

  def index
    @orders = current_user.orders
  end
end

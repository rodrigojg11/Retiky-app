class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @tickets = Ticket.all

    @tickets = @tickets.where("LOWER(origin) LIKE ?", "%#{params[:from].downcase}%") if params[:from].present?
    @tickets = @tickets.where("LOWER(destination) LIKE ?", "%#{params[:to].downcase}%") if params[:to].present?
    @tickets = @tickets.where(departure_date: Date.parse(params[:date])) if params[:date].present?

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "tickets_list", locals: { tickets: @tickets } }
    end
  end
end

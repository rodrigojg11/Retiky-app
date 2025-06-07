class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @offers = Offer.all

    @offers = @offers.where("LOWER(origin) LIKE ?", "%#{params[:from].downcase}%") if params[:from].present?
    @offers = @offers.where("LOWER(destination) LIKE ?", "%#{params[:to].downcase}%") if params[:to].present?
    @offers = @offers.where(departure_date: Date.parse(params[:date])) if params[:date].present?

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "offers_list", locals: { offers: @offers } }
    end
  end
end

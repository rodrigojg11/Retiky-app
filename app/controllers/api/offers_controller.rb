module Api
  class OffersController < ApplicationController
    def index
      offers = Offer.all

      if params[:from].present?
        offers = offers.where("LOWER(origin) LIKE ?", "%#{params[:from].downcase}%")
      end

      if params[:to].present?
        offers = offers.where("LOWER(destination) LIKE ?", "%#{params[:to].downcase}%")
      end

      if params[:date].present?
        begin
          date = Date.parse(params[:date])
          offers = offers.where(departure_date: date)
        rescue ArgumentError
          # invalid date format, ignore
        end
      end

      render json: offers
    end
  end
end

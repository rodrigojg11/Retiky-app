require 'net/http'
require 'uri'
require 'json'

class FlightController < ApplicationController
  def search
    if params[:from].present? && params[:to].present?
      from = params[:from].upcase
      to = params[:to].upcase
      api_key = "73233fdea97ba2f77ab80b40cc139f75"

      url = URI("http://api.aviationstack.com/v1/flights?access_key=#{api_key}&dep_iata=#{from}&arr_iata=#{to}&limit=10")

      response = Net::HTTP.get(url)
      data = JSON.parse(response)

      @flights = data["data"]
    else
      @flights = []
    end
  end
end

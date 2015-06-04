class WeatherController < ApplicationController
  before_action :check_parameters

  def current
    render json: Weather.current_weather(location_params)
  end

  private

  def check_parameters
    unless params[:lat].present? && params[:lon].present?
      render json: { error: "Request requires lat and lon parameters" }, status: :bad_request
    end
  end

  def location_params
    params.permit(:lat, :lon)
  end
end

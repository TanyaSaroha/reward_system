class RewardsController < ApplicationController

  def calculate
    service = Rewards::Driver.new(params["file"])
    return render json: { errors: service.errors }, status: :unprocessable_entity if service.errors.present?

    render json: service.get_points, status: :ok
  end

end

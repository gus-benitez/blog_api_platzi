class HealthController < ApplicationController
  def health
    render json: {api: 'OK'}, status: :ok
    # :ok = 200 
  end
end

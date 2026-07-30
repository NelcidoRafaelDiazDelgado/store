class DashboardController < ApplicationController
  include Pagy::Backend

  def index
      @pagy, @products = pagy(Product
      .order(updated_at: :desc))
  end
end

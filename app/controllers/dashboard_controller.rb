class DashboardController < ApplicationController
  include Pagy::Backend

  layout "dashboard"
  def index
      @pagy, @products = pagy(Product
      .order(updated_at: :desc))

      @email = Current.user.email_address
  end
end

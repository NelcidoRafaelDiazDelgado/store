class DashboardController < ApplicationController
  include Pagy::Backend

  allow_unauthenticated_access
  layout "dashboard"
  def index
      @pagy, @products = pagy(Product
      .order(updated_at: :desc))

      @email = Current.user&.email_address || "No autenticado"
  end
end

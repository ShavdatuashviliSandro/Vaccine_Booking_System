class OrderCancellationsController < ApplicationController
  def index
    @orders=Order.all
  end

  def fetch_order_code
    @orders=Order.find_by(order_code: params[:order_code])
    if @orders&.patient&.mobile_phone == params[:mobile_phone]
      render partial: 'form'
    else
      render partial: 'error'
    end
  end
end

class OrderCancellationsController < ApplicationController
  def index
    @cancellations=Order.where("order_code LIKE ?", "%#{params[:search]}%")
    # @patient=Order.includes(:patient)
  end

  # def destroy
  #   @cancellations=Order.find(params[:id])
  #   @cancellations.destroy
  # end

  def change_status
    @current_order=Order.find_by(order_code: 1005)
    @current_order.finished=false
  end
end

# @cancellations=Order.where("order_code LIKE ?", "%#{params[:search]}%")
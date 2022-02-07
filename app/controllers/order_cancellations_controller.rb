class OrderCancellationsController < ApplicationController
  def index; end

  def fetch_order_code
    @order_code_value = params[:order_code]
    session[:passed_variable] = @order_code_value

    @orders=Order.find_by(order_code: params[:order_code])

    if @orders&.patient&.mobile_phone == params[:mobile_phone]
      render partial: 'form'
    else
      render partial: 'error'
    end
  end

  def create
    @order_code_value = session[:passed_variable]
    @get_value=@order_code_value

    @orders=Order.find_by(order_code: @get_value)

      if @orders.finished?
        @orders.finished=false
        @orders.save
        redirect_to root_url, notice: I18n.t('web.order_cancellation.list.order_cancel')
      else
        @orders.finished=true
        @orders.save
        redirect_to root_url, notice: I18n.t('web.order_cancellation.list.order_cancel')
      end
  end

  def call
    @booking=Booking.find_by(order_id: params[:order_id])
    sms=Web::GenerateVerifySmsService.new(@booking).call
    SendVerifySmsWorker.perform_async(sms.id)
  end

end

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

  def change_status
    @verify_sms_value=params[:search_sms]
    @order_code_value = session[:passed_variable]

    @orders=Order.find_by(order_code: @order_code_value)

    @booking=Booking.find_by(order_id: @orders.id)
    @verify_sms=VerifySmsMessage.where(booking_id: @booking.id).last
    if @verify_sms_value==@verify_sms.code
      if @orders.finished?
        order_cancel
      else
        order_reactive
      end
    end
  end

  def call
    @booking=Booking.find_by(order_id: params[:order_id])
    sms=Web::GenerateVerifySmsService.new(@booking).call
    SendVerifySmsWorker.perform_async(sms.id)
  end

  private

  def order_cancel
    @orders.finished=false
    @orders.save
    redirect_to root_url, notice: I18n.t('web.order_cancellation.list.order_cancel')
  end

  def order_reactive
    @orders.finished=true
    @orders.save
    redirect_to root_url, notice: I18n.t('web.order_cancellation.list.order_cancel')
  end
end

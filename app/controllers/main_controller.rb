class MainController < ApplicationController
  require 'browser'
  before_action :fetch_booking, only: %i[current_step next_step prev_step]
  before_action :clear_booking
  include DowncaseHelper
  def index
    @vaccine_items = VaccinesItem.active

    @bu_unit_slot = BusinessUnitSlot.all

    @slots =
      BusinessUnitSlot
        .select('bus.id, bus.duration, bus.start_date::date AS current_start_date, slots.item AS slot_item')
        .from(@bu_unit_slot.active, 'bus')
        .joins(
          "LEFT JOIN LATERAL (
          SELECT generate_series(bus.start_date, bus.end_date, bus.duration * '1 minutes'::interval)::timestamp as item
        ) slots ON true"
        )
        .joins(
          'LEFT JOIN orders o ON o.business_unit_slot_id = bus.id
          AND o.finished = true AND o.order_date::timestamp = slots.item'
        )
        .where('o.id IS NULL')
        .where('slots.item >= ?', Time.current)

  end
  browser = Browser.new("Some User Agent", accept_language: "en-us")
  def current_step
    result= Web::CurrentStepService.call(booking: @booking, params: params)

    if result.success? && result.record.present?
      assign_step_variables({vaccine: result.current_vaccine, record: result.record})
      cookies.signed[:booking_uuid] = { value: result.booking.guid, expires: 30.minutes.from_now }
      render "main/steps/step#{result.render_step}"
    else
      cookies.delete(:booking_uuid)
      redirect_to root_url, notice: result.message
    end
  end
  def next_step
    return redirect_to root_url, notice: I18n.t('web.main.session_expired') unless @booking
    result = Web::NextStepService.call(booking: @booking, params: params)
    if result.success?
      if result.last_step?
        cookies.delete(:booking_uuid)
        return redirect_to root_url, notice: I18n.t('web.main.booking_success')
      end
      redirect_to current_step_path(result.booking.vaccine&.name)
    else
      assign_step_variables({ vaccine: result.booking.vaccine, record: result.record })
      render "main/steps/step#{result.current_step}"
    end
  end

  def prev_step
    return redirect_to root_url, notice: I18n.t('web.main.session_expired') unless @booking
    result = Web::PrevStepService.call(booking: @booking, params: params)

    if result.success?
      if result.current_step==0
        delete_cookies
      else
        redirect_to current_step_path(result.booking.vaccine&.name&.downcase)
      end
    else
      assign_step_variables({ vaccine: result.booking.vaccine, record: result.record })

      render "main/steps/step#{result.current_step}"
    end
  end


  private

  def fetch_booking
    booking_uuid = cookies.signed[:booking_uuid]

    if booking_uuid.present?
      @booking = Booking.find_by(guid: booking_uuid)
    end
  end

  def assign_step_variables(attrs)
    @current_vaccine=attrs[:vaccine]
    @record=attrs[:record]
  end

  def clear_booking
    if @booking&.finished?
      delete_cookies
    end
  end

  def delete_cookies
    cookies.delete(:booking_uuid)
    redirect_to root_path
  end
end
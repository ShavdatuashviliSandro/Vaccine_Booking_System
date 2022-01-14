module Web
  class Step0Service
    attr_accessor :current_vaccine, :record, :booking, :user_ip, :browser

    def initialize(vaccine,browser,user_ip)
      @vaccine = vaccine
      @browser = browser
      @user_ip = user_ip
    end

    def call(current_booking)
      @record = current_booking&.patient || Patient.new
      @current_vaccine = current_booking&.vaccine || @vaccine
      @booking = current_booking || Booking.create(guid: SecureRandom.uuid, vaccine_id: @current_vaccine.id, ip_address: @user_ip, browser_name: @browser.name, os_name: @browser.platform.name )

    end
  end
end
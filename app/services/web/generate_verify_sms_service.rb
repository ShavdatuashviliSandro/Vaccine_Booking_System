module Web
  class GenerateVerifySmsService
    attr_reader :booking

    def initialize(booking)
      @booking = booking
    end

    def call
      VerifySmsMessage.create!(booking_id: booking.id, code: random_code, approved_at: current_time)
    end

    private

    def random_code
      rand(10000)
    end

    def current_time
      DateTime.now
    end

  end
end
module Admin
  class OrderSmsMessagesController < ApplicationController
    def index
      @pagy,@messages = pagy( OrderSmsMessage.all )
    end
  end
end
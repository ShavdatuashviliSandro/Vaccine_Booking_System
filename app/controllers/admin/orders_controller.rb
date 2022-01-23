module Admin
  class OrdersController < ApplicationController
    def index
      @pagy,@orders = pagy( Order.all )
    end
  end
end
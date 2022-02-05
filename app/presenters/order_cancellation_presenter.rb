class OrderCancellationPresenter < Struct.new(:order)
  def initialize(model)
    @model = model
    super(@model)
  end

  def business_unit
    @model.business_unit_slot&.business_unit&.name
  end

  def address
    "#{@model.business_unit_slot&.business_unit&.country.name},
     #{@model.business_unit_slot&.business_unit&.city.name},
     #{@model.business_unit_slot&.business_unit&.district.name}"
  end

  def order_time
    @model.order_date
  end

end


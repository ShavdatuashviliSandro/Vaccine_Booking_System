module BusinessUnits
  class BusinessUnitService
    attr_reader :current_user, :result

    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, business_unit: BusinessUnit.new)
    end

    def list
      BusinessUnit.all
    end

    def new
      result
    end

    def edit(id)
      find_record(id)
    end

    def create(params)
      result.tap do |r|
        r.business_unit = BusinessUnit.new(params)
        r.send("success?=", r.business_unit.save)
      end
    rescue ActiveRecord::StatementInvalid
      result.tap do |r|
        r.business_unit.errors.add(:base, I18n.t('admin.slots.errors.duplicate_slot_error'))
      end
    end

    def update(id, params)

      find_record(id)

      result.tap do |r|
        r.send("success?=", r.business_unit.update(params))
      end
    rescue ActiveRecord::StatementInvalid
      result.tap do |r|
        r.business_unit.errors.add(:base, I18n.t('admin.slots.errors.duplicate_slot_error'))
      end
    end

    def delete(id)
      find_record(id)

      result.tap do |r|
        r.send("success?=", r.business_unit.destroy)
      end
    end

    private

    def find_record(id)
      result.business_unit = BusinessUnit.find(id)
      result
    end
  end
end
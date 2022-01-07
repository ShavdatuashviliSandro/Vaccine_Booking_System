module VaccinesItems
  class VaccinesItemService
    attr_reader :current_user, :result

    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, vaccines_item: VaccinesItem.new)
    end

    def list
      VaccinesItem.all
    end

    def new
      result
    end

    def edit(id)
      find_record(id)
    end

    def create(params)
      result.tap do |r|
        r.vaccines_item = VaccinesItem.new(params)
        r.send("success?=", r.vaccines_item.save)
      end
    end

    def update(id, params)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.vaccines_item.update(params))
      end
    end

    def delete(id)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.vaccines_item.destroy)
      end
    end

    private

    def find_record(id)
      result.vaccines_item = VaccinesItem.find(id)
      result
    end
  end
end
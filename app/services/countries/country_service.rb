module Countries
  class CountryService
    attr_reader :current_user, :result

    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, country: Country.new)
    end

    def list
      Country.all
    end

    def new
      result
    end

    def edit(id)
      find_record(id)
    end

    def create(params)
      result.tap do |r|
        r.country = Country.new(params)
        r.send("success?=", r.country.save)
      end
    end

    def update(id, params)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.country.update(params))
      end
    end

    def delete(id)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.country.destroy)
      end
    end

    private

    def find_record(id)
      result.country = Country.find(id)
      result
    end
  end
end
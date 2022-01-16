module Patients
  class PatientService
    attr_reader :current_user, :result

    def initialize(current_user)
      @current_user = current_user
      @result = OpenStruct.new(success?: false, user: User.new)
    end

    def list
      Patient.all
    end

    def edit(id)
      find_record(id)
    end

    def update(id, params)
      find_record(id)
      result.tap do |r|
        r.send("success?=", r.patient.update(params))
      end
    end

    private

    def find_record(id)
      result.patient = Patient.find(id)
      result
    end
  end
end
module Admin
  class BusinessUnitsController < ApplicationController
    before_action :init_service

    def index
      @pagy, @business_units = pagy(@business_unit_service.list)
    end

    def new
      result = @business_unit_service.new

      @business_unit = result.business_unit
    end

    def edit
      result = @business_unit_service.edit(params[:id])

      @business_unit = result.business_unit
    end

    def create
      result = @business_unit_service.create(business_unit_params)

      @business_unit = result.business_unit

      if result.success?
        redirect_to admin_business_units_path, notice: I18n.t('admin.business_units.list.created')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      result = @business_unit_service.update(params[:id], business_unit_params)

      @business_unit = result.business_unit

      if result.success?
        redirect_to admin_business_units_path, notice: I18n.t('admin.business_units.list.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      result = @business_unit_service.delete(params[:id])

      if result.success?
        redirect_to admin_business_units_path, notice: I18n.t('admin.business_units.list.deleted')
      end
    end

    def fetch_cities
      @cities = City.active.where(country_id: params[:country_id])
      render partial: 'cities', object: @cities, layout: false
    end

    def fetch_districts
      @districts = District.active.where(city_id: params[:city_id])
      render partial: 'districts', object: @districts, layout: false
    end

    private

    def init_service
      @business_unit_service = BusinessUnits::BusinessUnitService.new(current_user)
    end

    def business_unit_params
      params
        .require(:business_unit)
        .permit(:country_id, :city_id, :district_id, :name, :code, :active)
    end
  end
end
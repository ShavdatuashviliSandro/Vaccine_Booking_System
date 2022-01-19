module Admin
  class CitiesController < ApplicationController
    before_action :init_service
    def index
      @pagy,@city = pagy(@cities_service.list)
    end
    def new
      result=@cities_service.new
      @city = result.city
    end
    def edit
      result=@cities_service.edit(params[:id])
      @city = result.city
    end
    def create
      result=@cities_service.create(create_cities_params)
      @city=result.city

      if result.success?
        redirect_to admin_cities_path, notice: I18n.t('admin.cities.list.created')
      else
        render :new, status: :unprocessable_entity
      end
    end
    def update
      result = @cities_service.update(params[:id],update_cities_params)
      @city=result.city

      if result.success?
        redirect_to admin_cities_path, notice:  I18n.t('admin.cities.list.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
    def destroy
      result=@cities_service.delete(params[:id])
      if result.success?
        redirect_to admin_cities_path, notice:  I18n.t('admin.cities.list.deleted')
      end
    end
    private

    def init_service
      @cities_service= Cities::CityService.new(@current_user)
    end

    def create_cities_params
      params.require(:city).permit(:country_id, :name, :code, :active)
    end
    def update_cities_params
      params.require(:city).permit(:id, :country_id, :name, :code, :active)
    end
  end
end
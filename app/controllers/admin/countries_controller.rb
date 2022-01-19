module Admin
  class CountriesController < ApplicationController
    before_action :init_service
    def index
      @pagy,@country = pagy(@countries_service.list)
    end
    def new
      result=@countries_service.new
      @country = result.country
    end
    def edit
      result=@countries_service.edit(params[:id])
      @country = result.country
    end
    def create
      result=@countries_service.create(create_countries_params)
      @country=result.country

      if result.success?
        redirect_to admin_countries_path, notice: I18n.t('admin.countries.list.created')
      else
        render :new, status: :unprocessable_entity
      end
    end
    def update
      result = @countries_service.update(params[:id],update_countries_params)
      @country=result.country

      if result.success?
        redirect_to admin_countries_path, notice:  I18n.t('admin.countries.list.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
    def destroy
      result=@countries_service.delete(params[:id])
      if result.success?
        redirect_to admin_countries_path, notice:  I18n.t('admin.countries.list.deleted')
      end
    end
    private

    def init_service
      @countries_service= Countries::CountryService.new(@current_user)
    end

    def create_countries_params
      params.require(:country).permit(:name, :code, :active)
    end
    def update_countries_params
      params.require(:country).permit( :id, :name, :code, :active)
    end
  end
end
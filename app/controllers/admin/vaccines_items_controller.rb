module Admin
  class VaccinesItemsController < ApplicationController
    before_action :init_service
    def index
      @pagy,@vaccines_item = pagy(@vaccines_items_service.list)
    end
    def new
      result=@vaccines_items_service.new
      @vaccines_item = result.vaccines_item
    end
    def edit
      result=@vaccines_items_service.edit(params[:id])
      @vaccines_item = result.vaccines_item
    end
    def create
      result=@vaccines_items_service.create(create_vaccines_item_params)
      @vaccines_item=result.vaccines_item

      if result.success?
        redirect_to admin_vaccines_items_path, notice: I18n.t('admin.users.notices.created')
      else
        render :new, status: :unprocessable_entity
      end
    end
    def update
      result = @vaccines_items_service.update(params[:id],update_vaccines_items_params)
      @vaccines_item=result.vaccines_item

      if result.success?
        redirect_to admin_vaccines_items_path, notice:  I18n.t('admin.users.notices.updated')
      else
        render :edit, status: :unprocessable_entity
      end
    end
    def destroy
      result=@vaccines_items_service.delete(params[:id])
      if result.success?
        redirect_to admin_vaccines_items_path, notice:  I18n.t('admin.users.notices.destroyed')
      end
    end
    private

    def init_service
      @vaccines_items_service= VaccinesItems::VaccinesItemService.new(@current_user)
    end

    def create_vaccines_item_params
      params.require(:vaccines_item).permit(:name, :active)
    end
    def update_vaccines_items_params
      params.require(:vaccines_item).permit( :id, :name, :active)
    end
  end
end
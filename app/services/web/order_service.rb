# module Web
#   class OrderService
#     attr_reader :current_user, :result
#
#     def initialize(current_user)
#       @current_user = current_user
#       @result = OpenStruct.new(success?: false, order: Order.new)
#     end
#
#     def list
#       Order.all
#     end
#
#     def new
#       result
#     end
#
#     def edit(id)
#       find_record(id)
#     end
#
#     def create(params)
#       result.tap do |r|
#         r.order = Order.new(params)
#         r.send("success?=", r.order.save)
#       end
#     end
#
#     def update(id, params)
#       find_record(id)
#       result.tap do |r|
#         r.send("success?=", r.order.update(params))
#       end
#     end
#
#     def delete(id)
#       find_record(id)
#       result.tap do |r|
#         r.send("success?=", r.order.destroy)
#       end
#     end
#
#     private
#
#     def find_record(id)
#       result.order = Order.find(id)
#       result
#     end
#   end
# end
#
#
# #######################
# class OrdersController < ApplicationController
#   before_action :init_service
#   def index
#     @q = Order.ransack(params[:q])
#     @order = @q.result
#   end
#   def new
#     result=@orders_service.new
#     @order = result.order
#   end
#   def edit
#     result=@orders_service.edit(params[:id])
#     @order = result.order
#   end
#   def create
#     result=@orders_service.create(create_districts_params)
#     @order=result.order
#
#     if result.success?
#       redirect_to orders_path, notice: I18n.t('admin.district.list.created')
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end
#   def update
#     result = @orders_service.update(params[:id],update_districts_params)
#     @order = result.order
#
#     if result.success?
#       redirect_to orders_path, notice:  I18n.t('admin.district.list.updated')
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end
#   def destroy
#     result=@orders_service.delete(params[:id])
#     if result.success?
#       redirect_to orders_path, notice:  I18n.t('admin.district.list.deleted')
#     end
#   end
#   private
#
#   def init_service
#     @orders_service= Web::OrderService.new(@current_user)
#   end
#
#   def create_districts_params
#     params.require(:order).permit(:business_unit_slot_id, :patient_id, :order_code, :order_date,:finished)
#   end
#   def update_districts_params
#     params.require(:order).permit( :id, :business_unit_slot_id, :patient_id, :order_code, :order_date,:finished)
#   end
# end
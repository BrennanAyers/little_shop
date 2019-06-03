class Merchants::OrdersController < Merchants::BaseController
  def show
    @merchant = current_user
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = @order.order_items.map {|order_item| order_item if order_item.item.user_id == @merchant.id}.compact
  end

  def index
    @user = current_user
    @orders = @user.pending_orders
    @placeholder_image_items = @user.placeholder_image_items
  end
end

class Default::OrdersController < Default::BaseController
  def index
    @user = current_user
    @orders = @user.orders
  end

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @user = User.find(@order.address.user_id)
  end

  def edit
    @order = Order.find(params[:id])
    @user = User.find(@order.address.user_id)
    @other_addresses = @user.addresses - [@order.address]
  end

  def update
    @order = Order.find(params[:id])
    changed_address = Address.find(params[:address_id])
    @order.update(address: changed_address)
    redirect_to profile_order_path(@order)
  end

  def destroy
    @order = Order.find(params[:id])
    @order.update(status: :cancelled)
    @order.order_items.each do |order_item|
      order_item.update(fulfilled: false)
    end
    flash[:notice] = "#{@order.id} has been cancelled."

    redirect_to profile_orders_path
  end

  def create
    cart = Cart.new(session[:cart])
    address_id = params[:address_id]
    if cart.contents.empty?
      carts_path
    else
      cart.create_order(address_id)
      session[:cart] = {}
      flash.notice = "Your Order Was Created"
      redirect_to profile_orders_path
    end
  end
end

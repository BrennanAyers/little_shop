class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:notice] = "Address #{@address.nickname} has been updated!"
      redirect_to profile_path
    else
      render :edit
    end
  end

  def destroy
    @address = Address.destroy(params[:id])

    flash[:notice] = "#{@address.nickname} Address was deleted."
    redirect_to profile_path
  end

  private

  def address_params
      params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end
end

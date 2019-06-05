require 'rails_helper'

RSpec.describe 'As a visitor' do
  context 'As a visitor' do

    it 'When my cart is empty and I visit my cart, It says my cart is empty' do
      visit carts_path

      expect(page).to have_content('Your cart is currently empty.')
      expect(page).to_not have_content('Empty your Cart')
    end

    it 'shows all items in my cart and allows user to clear cart' do
      merchant = create(:user, name: "Merchant", role: 1)
      item_1 = create(:item, user: merchant)

      visit items_path

      within "#item-#{item_1.id}" do
        click_link "Add To Cart"
      end

      click_link('Cart')

      expect(page).to have_content('You must register or login to checkout.')
      expect(page).to have_link('register')
      expect(page).to have_link('login')

      click_link('register')

      expect(current_path).to eq(register_path)

      click_link('Cart')
      click_link('login')

      expect(current_path).to eq(login_path)

    end

    it 'doesnt have a checkout link with items in cart' do
      merchant = create(:user, name: "Merchant", role: 1)
      item_1 = create(:item, user: merchant)
      item_2 = create(:item, user: merchant)
      item_3 = create(:item, user: merchant)

      visit items_path

      within "#item-#{item_1.id}" do
        click_link "Add To Cart"
      end

      visit carts_path

      expect(page).to_not have_link("Checkout")

    end
  end

  describe 'As a visitor or a registered user' do
    describe 'when I have items in my cart and view my cart' do

      before :each do
        @merchant = create(:user, name: "Merchant", role: 1)
        @item_1 = create(:item, user: @merchant)
        @item_2 = create(:item, user: @merchant)
        @item_3 = create(:item, user: @merchant)
      end


      it 'shows all items in my cart and allows user to clear cart' do
        visit items_path

        within "#item-#{@item_1.id}" do
          click_link "Add To Cart"
        end

        within "#item-#{@item_2.id}" do
          click_link "Add To Cart"
          click_link "Add To Cart"
        end

        within "#item-#{@item_3.id}" do
          click_link "Add To Cart"
          click_link "Add To Cart"
          click_link "Add To Cart"
        end

        visit carts_path

        within '#cart_total' do
          expect(page).to have_content("$120.00")
        end

        within "#item-#{@item_1.id}" do
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@item_1.user.name)
          expect(page).to have_content(@item_1.price)
          expect(page).to have_content(1)
          expect(page).to have_content("$20.00")
          find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
        end

        within "#item-#{@item_2.id}" do
          expect(page).to have_content(@item_2.name)
          expect(page).to have_content(@item_2.user.name)
          expect(page).to have_content(@item_2.price)
          expect(page).to have_content(2)
          expect(page).to have_content("$40.00")
          find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
        end

        within "#item-#{@item_3.id}" do
          expect(page).to have_content(@item_3.name)
          expect(page).to have_content(@item_3.user.name)
          expect(page).to have_content(@item_3.price)
          expect(page).to have_content(3)
          expect(page).to have_content("$60.00")
          find "img[src='https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg']"
        end

        click_link "Clear Cart"

        expect(page).to_not have_content(@item_1.name)
        expect(page).to_not have_content(@item_2.name)
        expect(page).to_not have_content(@item_3.name)
        expect(page).to have_content("(0)")
      end
    end
  end

  describe 'when i have items in my card' do
    before :each do
      merchant_1 = create(:user)
      merchant_2 = create(:user)
      @item_1 = create(:item, user: merchant_1)
      @item_2 = create(:item, user: merchant_1)
      @item_3 = create(:item, user: merchant_1)
      @item_4 = create(:item, user: merchant_2)
      @item_5 = create(:item, user: merchant_2, active: false)
      @item_6 = create(:item, user: merchant_2, active: false)
      buyer_1 = create(:user)
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: buyer_1)
      buyer_2 = create(:user)
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: buyer_2)
      buyer_3 = create(:user)
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: buyer_3)
      buyer_4 = create(:user)
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: buyer_4)
      order_1 = create(:order, address: buyer_1.addresses.first)
      order_2 = create(:order, address: buyer_1.addresses.first)
      order_3 = create(:order, address: buyer_2.addresses.first)
      order_4 = create(:order, address: buyer_2.addresses.first)
      order_5 = create(:order, address: buyer_3.addresses.first)
      order_6 = create(:order, address: buyer_3.addresses.first)
      order_7 = create(:order, address: buyer_3.addresses.first)
      order_8 = create(:order, address: buyer_2.addresses.first)
      order_9 = create(:order, address: buyer_1.addresses.first)
      order_10 = create(:order, address: buyer_3.addresses.first)
      order_11 = create(:order, address: buyer_4.addresses.first)
      OrderItem.create!(item: @item_1, order: order_1, quantity: 12, price: 1.99, fulfilled: true)
      OrderItem.create!(item: @item_2, order: order_2, quantity: 3, price: 6.99, fulfilled: true)
      OrderItem.create!(item: @item_3, order: order_3, quantity: 6, price: 11.99, fulfilled: true)
      OrderItem.create!(item: @item_4, order: order_4, quantity: 7, price: 12.99, fulfilled: true)
      OrderItem.create!(item: @item_5, order: order_5, quantity: 14, price: 13.99, fulfilled: true)
      OrderItem.create!(item: @item_6, order: order_6, quantity: 5, price: 2.99, fulfilled: true)
      OrderItem.create!(item: @item_1, order: order_7, quantity: 21, price: 9.99, fulfilled: true)
      OrderItem.create!(item: @item_2, order: order_8, quantity: 31, price: 7.99, fulfilled: true)
      OrderItem.create!(item: @item_3, order: order_9, quantity: 2, price: 12.99, fulfilled: false)
      OrderItem.create!(item: @item_4, order: order_10, quantity: 3, price: 11.99, fulfilled: false)
      OrderItem.create!(item: @item_5, order: order_11, quantity: 1, price: 21.99, fulfilled: false)
    end

    it 'has a remove item from cart' do
      visit items_path


      within "#item-#{@item_1.id}" do
        click_link "Add To Cart"
      end

      within "#item-#{@item_2.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      within "#item-#{@item_3.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      visit carts_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_link('Remove Item')
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link('Remove Item')
      end

      within "#item-#{@item_3.id}" do
        expect(page).to have_link('Remove Item')
      end

      within "#item-#{@item_1.id}" do
        click_link "Remove Item"
      end

      expect(page).to_not have_content(@item_1.name)
    end

    it 'has a increment item on cart show' do
      visit items_path


      within "#item-#{@item_1.id}" do
        click_link "Add To Cart"
      end

      within "#item-#{@item_2.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      within "#item-#{@item_3.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      visit carts_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_link('Add One')
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link('Add One')
      end

      within "#item-#{@item_3.id}" do
        expect(page).to have_link('Add One')
      end

      within "#item-#{@item_1.id}" do
        click_link "Add One"
        expect(page).to have_content(2)
      end
    end

    it 'has a decrease item on cart show' do
      visit items_path


      within "#item-#{@item_1.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      within "#item-#{@item_2.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      within "#item-#{@item_3.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      visit carts_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_link('Remove One')
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_link('Remove One')
      end

      within "#item-#{@item_3.id}" do
        expect(page).to have_link('Remove One')
      end

      within "#item-#{@item_1.id}" do
        click_link "Remove One"
        expect(page).to have_content(1)
        click_link "Remove One"
      end

      expect(page).to_not have_content(@item_1.name)
    end
  end
end

describe 'As a registered user' do
  describe 'when viewing my cart with items in it' do
    before :each do
      @user = create(:user, password: 'password')
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: @user)
      @address = @user.addresses.first
      @merchant = create(:user, name: "Merchant", role: 1)
      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)

      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: 'password'
      click_button 'Login'

      visit items_path

      within "#item-#{@item_1.id}" do
        click_link "Add To Cart"
      end

      within "#item-#{@item_2.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
      end

      within "#item-#{@item_3.id}" do
        click_link "Add To Cart"
        click_link "Add To Cart"
        click_link "Add To Cart"
      end
    end

    it 'allows me to checkout with home' do
      visit carts_path

      click_link 'Checkout with Home'
      order = Order.last
      expect(order.status).to eq("pending")
      expect(order.address).to eq(@address)
      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your Order Was Created")
    end

    it 'allows me to checkout with work' do
      create(:address, address: "123 ugh Lane", city: "Helpen", state: "Sad", zip: "00000", user: @user, nickname: "Work")
      @user.reload
      work = @user.addresses.last
      visit carts_path

      click_link 'Checkout with Work'
      order = Order.last
      expect(order.status).to eq("pending")
      expect(order.address).to eq(work)
      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your Order Was Created")
    end

    it 'does not allow me to checkout without an address' do
      visit profile_path
      click_link "Delete Home"
      visit carts_path

      expect(page).to have_content("You need to add an address to check out!")
      click_link "Checkout with New Address"

      fill_in "Nickname", with: "Away"
      fill_in "Address", with: "666 Fire Rd"
      fill_in "City", with: "Newark"
      fill_in "State", with: "Joisey"
      fill_in "Zip", with: "96669"

      click_button "Create Address"

      away = @user.addresses.first

      visit carts_path

      click_link 'Checkout with Away'
      order = Order.last
      expect(order.status).to eq("pending")
      expect(order.address).to eq(away)
      expect(current_path).to eq(profile_orders_path)
      expect(page).to have_content("Your Order Was Created")
    end

    it 'shows my order on my orders page' do
      visit carts_path

      click_link 'Checkout with Home'
      order = Order.last
      within "#order-#{order.id}" do
        expect(page).to have_link("Order ID: #{order.id}")
      end
    end

    it 'clears my cart' do
      visit carts_path

      click_link 'Checkout with Home'
      within '#navbarNav' do
        expect(page).to have_content("(0)")
      end
    end
  end
end

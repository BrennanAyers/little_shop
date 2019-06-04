require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant show page', type: :feature do
  context 'As a merchant user' do
    describe 'When I visit my dashboard' do
      before :each do
        @merchant = create(:user, role: 1)
        @item_1 = create(:item, user: @merchant)
        @item_2 = create(:item, user: @merchant)
        @item_3 = create(:item, user: @merchant)
        @item_4 = create(:item, user: @merchant)
        @user_1 = create(:user)
        @user_2 = create(:user)
        @user_3 = create(:user)
        @order_1 = create(:order, user: @user_1, status: 1)
        @order_2 = create(:order, user: @user_2, status: 1)
        @order_3 = create(:order, user: @user_3, status: 0)
        @order_4 = create(:order, user: @user_3, status: 0)
        OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_2, order: @order_2, quantity: 13, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_3, order: @order_3, quantity: 14, price: 1.99, fulfilled: false)
        OrderItem.create!(item: @item_3, order: @order_4, quantity: 15, price: 1.99, fulfilled: false)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'I see my profile data' do

        visit dashboard_path

        expect(page).to have_content(@merchant.email)
        expect(page).to have_content(@merchant.role)
        expect(page).to have_content(@merchant.active)
        expect(page).to have_content(@merchant.name)
        expect(page).to have_content(@merchant.address)
        expect(page).to have_content(@merchant.city)
        expect(page).to have_content(@merchant.state)
        expect(page).to have_content(@merchant.zip)
        expect(page).to_not have_content(@merchant.password_digest)
        expect(page).to_not have_link('Edit Profile')
      end

      it 'displays the orders for items a merchent sells' do
        visit dashboard_path


        within("#order-#{@order_1.id}") do
          expect(page).to have_link("#{@order_1.id}")
          expect(page).to have_content("Date created: #{@order_1.date_made}")
          expect(page).to have_content("Total quantity: #{@order_1.item_count}")
          expect(page).to have_content("Total price: #{@order_1.grand_total}")
        end

        within("#order-#{@order_2.id}") do
          expect(page).to have_link("#{@order_2.id}")
          expect(page).to have_content("Date created: #{@order_2.date_made}")
          expect(page).to have_content("Total quantity: #{@order_2.item_count}")
          expect(page).to have_content("Total price: #{@order_2.grand_total}")
        end

        expect(page).to_not have_link("#{@order_3.id}")
      end

      it 'has a link to redirect to my items page' do
        visit dashboard_path

        click_link('View My Items')

        expect(current_path).to eq(dashboard_items_path)

        expect(page).to have_content("Item Id: #{@item_1.id}")
        expect(page).to have_content("Item Id: #{@item_2.id}")
        expect(page).to have_content("Item Id: #{@item_3.id}")
        expect(page).to have_content("Item Id: #{@item_4.id}")
      end
    end

    describe 'To Do List' do
      before :each do
        @merchant = create(:user, role: 1)
        @item_1 = create(:item, user: @merchant, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
        @item_2 = create(:item, user: @merchant, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
        @item_3 = create(:item, user: @merchant, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
        @item_4 = create(:item, user: @merchant, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")

        @user_1 = create(:user)
        @user_2 = create(:user)
        @user_3 = create(:user)
        @order_1 = create(:order, user: @user_1, status: 1)
        @order_2 = create(:order, user: @user_2, status: 1)
        @order_3 = create(:order, user: @user_3, status: 0)
        @order_4 = create(:order, user: @user_3, status: 0)
        @order_item_1 = OrderItem.create!(item: @item_1, order: @order_1, quantity: 12, price: 1.99, fulfilled: false)
        @order_item_2 = OrderItem.create!(item: @item_2, order: @order_2, quantity: 13, price: 1.99, fulfilled: false)
        @order_item_3 = OrderItem.create!(item: @item_3, order: @order_3, quantity: 14, price: 1.99, fulfilled: false)
        @order_item_4 = OrderItem.create!(item: @item_3, order: @order_4, quantity: 15, price: 1.99, fulfilled: false)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      end

      it 'should tell me about placeholder images for cheeses I own' do
        @item_5 = Item.create!(name: "TestCheese", active: true, price: 10.00, description: "This cheese should have the default image.", image: "https://kaaskraam.com/wp-content/uploads/2018/02/Gouda-Belegen.jpg", inventory: 100, user: @merchant)
        visit dashboard_path

        within("#placeholder-images-list") do
          expect(page).to have_content("These items need new images!")

          expect(page).to_not have_content("#{@item_1.name} is currently using the default cheesey image, please fix this!")
          expect(page).to_not have_link(@item_1.name, href: edit_dashboard_item_path(@item_1))

          expect(page).to have_content("#{@item_5.name} is currently using the default cheesey image, please fix this!")
          expect(page).to have_link(@item_5.name, href: edit_dashboard_item_path(@item_5))
        end
      end

      it 'should tell me about my unfulfilled items and how much they are worth' do
        @order_item_5 = OrderItem.create!(item: @item_3, order: @order_1, quantity: 15, price: 1.99, fulfilled: false)
        visit dashboard_path

        within("#unfulfilled-items") do
          expect(page).to have_content("Unfulfilled Items")

          expect(page).to have_content("You have #{@merchant.unfulfilled_items.count} unfulfilled orders worth #{number_to_currency((@order_item_2.price * @order_item_2.quantity) + (@order_item_1.price * @order_item_1.quantity) + (@order_item_5.price * @order_item_5.quantity))}")
        end
      end
    end
  end
end

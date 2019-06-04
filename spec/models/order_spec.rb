require 'rails_helper'

RSpec.describe Order, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :items}
  end

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 1, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")
      @merchant_1 = create(:user)
      @merchant_2 = create(:user)
      @item_1 = create(:item, user: @merchant_1)
      @item_2 = create(:item, user: @merchant_1)
      @item_3 = create(:item, user: @merchant_1)
      @item_4 = create(:item, user: @merchant_2)
      @item_5 = create(:item, user: @merchant_2)
      @item_6 = create(:item, user: @merchant_2)
      travel_to Time.zone.local(2019, 04, 11, 8, 00, 00)
      @order_1 = create(:order, user: @user)
      travel_to Time.zone.local(2019, 05, 10, 18, 00, 00)
      @order_2 = create(:order, user: @user)
      travel_to Time.zone.local(2019, 05, 02, 12, 00, 00)
      @order_3 = create(:order, user: @user)
      travel_to Time.zone.local(2018, 01, 15, 14, 00, 00)
      @order_4 = create(:order, user: @user)
      travel_back
      order_item_1 = create(:order_item, order: @order_1, item: @item_1)
      order_item_2 = create(:order_item, order: @order_1, item: @item_2)
      order_item_3 = create(:order_item, order: @order_2, item: @item_2)
      order_item_4 = create(:order_item, order: @order_2, item: @item_3)
      order_item_5 = create(:order_item, order: @order_2, item: @item_5)
      order_item_6 = create(:order_item, order: @order_3, item: @item_1)
      order_item_7 = create(:order_item, order: @order_3, item: @item_6)
      order_item_8 = create(:order_item, order: @order_4, item: @item_5)
      order_item_9 = create(:order_item, order: @order_4, item: @item_2)
      order_item_10 = create(:order_item, order: @order_4, item: @item_3)
      order_item_11 = create(:order_item, order: @order_4, item: @item_1)
    end

    it '#date_made' do
      expect(@order_1.date_made).to eq("April 11, 2019")
      expect(@order_2.date_made).to eq("May 10, 2019")
      expect(@order_3.date_made).to eq("May 2, 2019")
      expect(@order_4.date_made).to eq("January 15, 2018")
    end

    it 'last_updated' do
      travel_to Time.zone.local(2019, 04, 12, 8, 00, 00)
      @order_1.update(status: 2)
      travel_to Time.zone.local(2019, 05, 11, 18, 00, 00)
      @order_2.update(status: 2)
      travel_to Time.zone.local(2019, 05, 03, 12, 00, 00)
      @order_3.update(status: 2)
      travel_to Time.zone.local(2018, 01, 16, 14, 00, 00)
      @order_4.update(status: 2)

      expect(@order_1.last_updated).to eq("April 12, 2019")
      expect(@order_2.last_updated).to eq("May 11, 2019")
      expect(@order_3.last_updated).to eq("May 3, 2019")
      expect(@order_4.last_updated).to eq("January 16, 2018")
    end

    it '#item_count' do
      expect(@order_1.item_count).to eq(2)
      expect(@order_2.item_count).to eq(3)
      expect(@order_3.item_count).to eq(2)
      expect(@order_4.item_count).to eq(4)
    end

    it '#grand_total' do
      expect(@order_1.grand_total).to eq(19.98)
      expect(@order_2.grand_total).to eq(29.97)
      expect(@order_3.grand_total).to eq(19.98)
      expect(@order_4.grand_total).to eq(39.96)
    end

    it '#check_fulfillments' do
      user = User.create!(email: "not_test@test.com", password_digest: "t3s7", role: 1, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")
      merchant_1 = create(:user)
      item_1 = create(:item, user: merchant_1)
      item_2 = create(:item, user: merchant_1)
      item_3 = create(:item, user: merchant_1)
      order_1 = create(:order, user: user, status: :pending)
      order_item_1 = create(:order_item, order: order_1, item: item_1)
      order_item_2 = create(:order_item, order: order_1, item: item_2)
      order_item_3 = create(:order_item, order: order_1, item: item_3)

      expect(order_1.status).to eq("pending")

      order_item_1.update!(fulfilled: true)
      order_item_2.update!(fulfilled: true)
      order_item_1.reload
      order_item_2.reload
      order_1.reload
      expect(order_1.status).to eq("pending")

      travel_to Time.zone.local(2044, 04, 12, 8, 00, 00)
      order_item_3.update!(fulfilled: true)
      order_item_3.reload
      order_1.reload
      expect(order_1.status).to eq("packaged")
    end

    it '#exceeds_inventory?' do
      merchant = create(:user, role: 1)
      item_1 = create(:item, user: merchant, inventory: 12, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
      item_2 = create(:item, user: merchant, inventory: 12, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
      item_3 = create(:item, user: merchant, inventory: 12, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")
      item_4 = create(:item, user: merchant, inventory: 12, image: "https://cdn.shopify.com/s/files/1/0150/0232/products/Pearl_Valley_Swiss_Slices_36762caf-0757-45d2-91f0-424bcacc9892_large.jpg?v=1534871055")

      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      order_1 = create(:order, user: user_1, status: 1)
      order_2 = create(:order, user: user_2, status: 1)
      order_3 = create(:order, user: user_3, status: 0)
      order_4 = create(:order, user: user_3, status: 0)
      order_item_1 = OrderItem.create!(item: item_1, order: order_1, quantity: 6, price: 1.99, fulfilled: false)
      order_item_2 = OrderItem.create!(item: item_2, order: order_2, quantity: 32, price: 1.99, fulfilled: false)
      order_item_3 = OrderItem.create!(item: item_3, order: order_3, quantity: 19, price: 1.99, fulfilled: false)
      order_item_4 = OrderItem.create!(item: item_3, order: order_4, quantity: 1, price: 1.99, fulfilled: false)

      expect(order_1.exceeds_inventory?).to eq(false)
      expect(order_2.exceeds_inventory?).to eq(true)
      # These two are cancelled so would not ever be called on
      expect(order_3.exceeds_inventory?).to eq(true)
      expect(order_4.exceeds_inventory?).to eq(false)
    end
  end

  describe 'class methods' do

    before :each do
      @merchant_1 = create(:user, role: 1, created_at: Date.new(1995, 5, 3), city: 'Kansas City', state: "MO")
      @merchant_2 = create(:user, role: 1, created_at: Date.new(2015, 12, 8), city: 'Springfield', state: 'CO')
      @merchant_3 = create(:user, role: 1, created_at: Date.new(2002, 9, 10), city: 'Springfield', state: 'MI')
      @merchant_4 = create(:user, role: 1, created_at: Date.new(1955, 3, 21), city: 'Little Rock', state: 'AR')
      @merchant_5 = create(:user, role: 1, active: false)
      @merchant_6 = create(:user, role: 1, active: false)
      user = create(:user)
      item_1 = create(:item, user: @merchant_1)
      item_2 = create(:item, user: @merchant_2)
      item_3 = create(:item, user: @merchant_3)
      item_4 = create(:item, user: @merchant_4)
      item_5 = create(:item, user: @merchant_1)
      item_6 = create(:item, user: @merchant_5)
      @order_1 = create(:order, user: user, status: 2)
      @order_2 = create(:order, user: user, status: 2)
      @order_3 = create(:order, user: user, status: 2)
      @order_4 = create(:order, user: user, status: 2)
      @order_5 = create(:order, user: user, status: 1)
      order_item_1 = OrderItem.create!(item: item_1, order: @order_1, quantity: 1, price: item_1.price, fulfilled: false, updated_at: Time.now + 30)
      order_item_2 = OrderItem.create!(item: item_2, order: @order_1, quantity: 2, price: item_2.price, fulfilled: false, updated_at: Time.now + 40)
      order_item_3 = OrderItem.create!(item: item_3, order: @order_1, quantity: 3, price: item_3.price, fulfilled: false, updated_at: Time.now + 50)
      order_item_4 = OrderItem.create!(item: item_4, order: @order_1, quantity: 4, price: item_4.price, fulfilled: false, updated_at: Time.now + 60)
      order_item_5 = OrderItem.create!(item: item_1, order: @order_2, quantity: 5, price: item_1.price, fulfilled: false, updated_at: Time.now + 80)
      order_item_6 = OrderItem.create!(item: item_2, order: @order_2, quantity: 6, price: item_2.price, fulfilled: false, updated_at: Time.now + 90)
      order_item_7 = OrderItem.create!(item: item_3, order: @order_2, quantity: 7, price: item_3.price, fulfilled: false, updated_at: Time.now + 100)
      order_item_8 = OrderItem.create!(item: item_1, order: @order_3, quantity: 8, price: item_1.price, fulfilled: false, updated_at: Time.now + 110)
      order_item_9 = OrderItem.create!(item: item_2, order: @order_3, quantity: 9, price: item_2.price, fulfilled: false, updated_at: Time.now + 120)
      order_item_10 = OrderItem.create!(item: item_1, order: @order_4, quantity: 10, price: item_1.price, fulfilled: false, updated_at: Time.now + 130)
      order_item_10 = OrderItem.create!(item: item_5, order: @order_1, quantity: 11, price: item_5.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_11 = OrderItem.create!(item: item_6, order: @order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)
      order_item_12 = OrderItem.create!(item: item_5, order: @order_5, quantity: 12, price: item_6.price, fulfilled: false, updated_at: Time.now + 70)

    end

    it '.biggest_3' do
      expect(Order.biggest_3[0]).to eq(@order_1)
      expect(Order.biggest_3[1]).to eq(@order_2)
      expect(Order.biggest_3[2]).to eq(@order_3)
      expect(Order.biggest_3.length).to eq(3)
    end

  end
end

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of :address}
    it { should validate_presence_of :city}
    it { should validate_presence_of :state}
    it { should validate_presence_of :zip}
  end

  describe 'relationships' do
    it { should belong_to :user}
    it { should have_many :orders}
  end

  describe 'instance methods' do
    before :each do
      @user = User.create!(email: "test@test.com", password: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @user.addresses << create(:address, address: "123 Test St", city: "Testville", state: "Testington", zip: "01234", user: @user)
      @user.addresses << create(:address, address: "100 Help Me", city: "Testville", state: "Testington", zip: "01234", user: @user)
      @address = @user.addresses.first
      @address_2 = @user.addresses.last
    end

    it '#modifiable?' do
      create(:order, status: 2, address: @address)
      @address.reload

      expect(@address.modifiable?).to eq(false)
      expect(@address_2.modifiable?).to eq(true)

      create(:order, status: 0, address: @address_2)
      @address_2.reload

      expect(@address_2.modifiable?).to eq(false)
    end
  end
end

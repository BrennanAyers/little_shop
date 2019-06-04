require 'rails_helper'

RSpec.describe 'As a Default user', type: :feature do
  describe 'When I visit an Address edit page' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @address = @user.addresses << create(:address, address: "123 Test St", city: "Testville", state: "Test", zip: "01234", user: @user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'should have a form to edit' do
      visit edit_address_path(@address)
      
      expect(page).to have_field("Address", with: "123 Test St")
      expect(page).to have_field("City", with: "Testville")
      expect(page).to have_field("State", with: "Test")
      expect(page).to have_field("Zip", with: "01234")
    end
  end
end

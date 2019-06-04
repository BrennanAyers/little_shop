require 'rails_helper'

RSpec.describe 'As a Default user', type: :feature do
  describe 'When I visit an Address edit page' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @user.addresses << create(:address, address: "123 Test St", city: "Testville", state: "Test", zip: "01234", user: @user)
      @address = @user.addresses.first

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'should have a form to edit' do
      visit edit_address_path(@address)

      expect(page).to have_field("Nickname", with: "Home")
      expect(page).to have_field("Address", with: "123 Test St")
      expect(page).to have_field("City", with: "Testville")
      expect(page).to have_field("State", with: "Test")
      expect(page).to have_field("Zip", with: "01234")
      expect(page).to have_button "Edit Address"
    end

    it 'should allow me to edit my address' do
      visit edit_address_path(@address)

      fill_in "Nickname", with: "Away"
      fill_in "Address", with: "666 Fire Rd"
      fill_in "City", with: "Newark"
      fill_in "State", with: "Joisey"
      fill_in "Zip", with: "96669"

      click_button "Edit Address"

      expect(current_path).to eq(profile_path)

      within "#address-#{@address.id}" do
        expect(page).to have_content("Address Nickname: Away")
        expect(page).to have_content("Address: 666 Fire Rd")
        expect(page).to have_content("City: Newark")
        expect(page).to have_content("State: Joisey")
        expect(page).to have_content("Zip Code: 96669")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'As a Default User', type: :feature do
  describe 'From my Profile page' do
    before :each do
      @user = User.create!(email: "test@test.com", password: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @user.addresses << create(:address, address: "123 Test St", city: "Testville", state: "Testington", zip: "01234", user: @user)
      @address = @user.addresses.first

      visit login_path
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      click_button "Login"
    end

    it 'I can get a form for a new address for myself' do
      visit profile_path

      expect(page).to have_link("New Address", href: new_profile_address_path)

      click_link "New Address"

      expect(current_path).to eq(new_profile_address_path)

      expect(page).to have_field("Nickname")
      expect(page).to have_field("Address")
      expect(page).to have_field("City")
      expect(page).to have_field("State")
      expect(page).to have_field("Zip")
      expect(page).to have_button "Create Address"
    end

    it 'I can create a new address for myself' do
      visit profile_path

      click_link "New Address"

      fill_in "Nickname", with: "Away"
      fill_in "Address", with: "666 Fire Rd"
      fill_in "City", with: "Newark"
      fill_in "State", with: "Joisey"
      fill_in "Zip", with: "96669"

      click_button "Create Address"

      expect(current_path).to eq(profile_path)

      expect(page).to have_content "Address Nickname: Away"
      expect(page).to have_content "Address: 666 Fire Rd"
      expect(page).to have_content "City: Newark"
      expect(page).to have_content "State: Joisey"
      expect(page).to have_content "Zip Code: 96669"
      expect(page).to have_link "Delete Away Address"
    end
  end
end

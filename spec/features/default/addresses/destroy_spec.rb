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

    it 'I can delete an address' do
      visit profile_path

      expect(page).to have_content(@address.address)
      expect(page).to have_content(@address.city)
      expect(page).to have_content(@address.state)
      expect(page).to have_content(@address.zip)

      expect(page).to have_link("Delete #{@address.nickname} Address", href: profile_address_path(@address))

      click_link "Delete #{@address.nickname} Address"

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@address.address)
      expect(page).to_not have_content(@address.city)
      expect(page).to_not have_content(@address.state)
      expect(page).to_not have_content(@address.zip)
    end
  end
end

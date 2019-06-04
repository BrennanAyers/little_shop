require 'rails_helper'

RSpec.describe 'As a Default User', type: :feature do
  describe 'From my Profile page' do
    before :each do
      @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson")
      @user.addresses << create(:address, address: "123 Test St", city: "Testville", state: "Test", zip: "01234", user: @user)
      @address = @user.addresses.first

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can delete an address' do
      visit profile_path

      expect(page).to have_content(@address.address)
      expect(page).to have_content(@address.city)
      expect(page).to have_content(@address.state)
      expect(page).to have_content(@address.zip)

      expect(page).to have_link("Delete #{@address.nickname} Address", href: address_path(@address))

      click_link "Delete Home Address"

      expect(current_path).to eq(profile_path)
      expect(page).to_not have_content(@address.address)
      expect(page).to_not have_content(@address.city)
      expect(page).to_not have_content(@address.state)
      expect(page).to_not have_content(@address.zip)
    end
  end
end

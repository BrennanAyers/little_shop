require 'rails_helper'

RSpec.describe 'As a registered User', type: :feature do
  context 'Default user' do
    describe 'And I click the link to edit my profile' do
      before :each do
        @user = User.create!(email: "test@test.com", password_digest: "t3s7", role: 0, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      end

      it 'Has the current path of /profile/edit' do
        visit profile_path

        click_link "Edit Profile"

        expect(current_path).to eq(profile_edit_path)
      end

      it 'Has a form to modify my information' do
        visit profile_edit_path

        expect(page).to have_field("Name")
        expect(page).to have_field("Password")
        expect(page).to have_field("Confirm Password")
        expect(page).to have_field("Email")

        expect(page).to have_button("Edit User")
      end

      it 'Has a form with my information already filled out, except Password/Confirm Password' do
        visit profile_edit_path

        expect(page).to have_field("Name", with: "Testy McTesterson")
        expect(find_field("Password").value).blank?
        expect(find_field("Confirm Password").value).blank?
        expect(page).to have_field("Email", with: "test@test.com")
      end

      it 'Can successfully edit one of my fields' do
        visit profile_edit_path

        fill_in "Name", with: "Testerino"

        click_button "Edit User"

        expect(current_path).to eq(profile_path)

        expect(page).to have_content("Your information has been updated!")
        expect(page).to have_content("Testerino")

        expect(@user.password_digest).to eq("t3s7")
      end

      it 'Can successfully edit all of my fields except password' do
        visit profile_edit_path

        fill_in "Name", with: "Testerino"
        fill_in "Email", with: "test@test.net"

        click_button "Edit User"

        expect(current_path).to eq(profile_path)

        expect(page).to have_content("Your information has been updated!")
        expect(page).to have_content("Testerino")
        expect(page).to have_content("test@test.net")

        expect(@user.password_digest).to eq("t3s7")
      end

      it 'Can successfully update a password' do
        visit profile_edit_path

        fill_in "Password", with: "newtest"
        fill_in "Confirm Password", with: "newtest"

        click_button "Edit User"

        expect(current_path).to eq(profile_path)
        expect(page).to have_content("Your information has been updated!")
        expect(@user.password_digest).to_not eq("t3s7")
      end

      it 'Will not allow an already existing users email' do
        other_user = User.create!(email: "test@test.net", password_digest: "t3s7", role: 1, active: true, name: "Testy McTesterson", address: "123 Test St", city: "Testville", state: "Test", zip: "01234")

        visit profile_edit_path

        fill_in "Email", with: "test@test.net"

        click_button "Edit User"

        expect(current_path).to eq(profile_edit_path)
        expect(page).to have_content("Email has already been taken")

        expect(page).to have_field("Email", with: "test@test.com")
      end

      it 'Will not allow not matching passwords' do
        visit profile_edit_path

        fill_in 'Password', with: 'password'
        fill_in 'Confirm Password', with: 'password3'

        click_button "Edit User"

        expect(current_path).to eq(profile_edit_path)
        expect(page).to have_content("Those passwords don't match.")
      end

      it 'Will not allow blank fields' do
        visit profile_edit_path

        fill_in 'Name', with: ''
        fill_in 'Email', with: ''

        click_button "Edit User"


        expect(current_path).to eq(profile_edit_path)
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Name can't be blank")
      end
    end
  end
end

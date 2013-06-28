require 'spec_helper'

describe "User pages" do

  subject { page }

  describe 'register page' do
    before { visit register_path }

    it { should have_content('Register') }
    it { should have_title(full_title('Register')) }
  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.username) }
    it { should have_title(user.username) }
  end

  describe 'registration' do
    before { visit register_path }

    let(:submit) { 'Register' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Username',     with: 'Example User'
        fill_in 'Email',        with: 'user@example.com'
        fill_in 'Password',     with: 'foobarfoobar'
        fill_in 'Password confirmation', with: 'foobarfoobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_link('Logout') }
        #it { should have_title(user.username) }
        #it { should have_selector('div.alert', text: 'Welcome') }
      end
    end
  end

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      login user
      visit edit_user_registration_path
    end

    describe 'page' do
      it { should have_content("Update profile") }
      it { should have_title(user.username) }
    end

    describe 'with invalid information' do
      before { click_button 'Save changes' }
      it { should have_content('error') }
    end

    describe 'with valid information' do
      let(:new_username)  { 'NewName' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Username',              with: new_username
        fill_in 'Email',                 with: new_email
        fill_in 'Password',              with: user.password
        fill_in 'Password confirmation', with: user.password
        fill_in 'Current password'     , with: user.password
        click_button 'Save changes'
      end

      #it { should have_title(new_username) }
      #it { should have_selector('div.alert') }
      it { should have_link('Logout', href: logout_path) }
      specify { expect(user.reload.username).to eq new_username.downcase }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end

require 'spec_helper'

describe 'Authentication' do

  subject { page }

  describe 'login page' do
    before { visit login_path }

    it { should have_title(full_title('Login')) }
  end

  describe 'login' do
    before { visit login_path }

    describe 'with invalid information' do
      before { click_button 'Login' }

      it { should have_title(full_title('Login')) }
      it { should have_selector('p.alert', text: 'Invalid') }

      describe 'after visiting another page' do
        before { click_link 'Healthy News' }
        it { should_not have_selector('p.alert', text: 'Invalid') }
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in 'Login',    with: user.username.upcase
        fill_in 'Password', with: user.password
        click_button 'Login'
      end

      #it { should have_title(user.username) }
      it { should have_link(user.username, href: user_path(user)) }
      it { should_not have_link('Login',   href: login_path) }

      describe 'followed by logout' do
        before { click_link 'Logout' }
        it { should have_link('Login') }
      end
    end
  end
end
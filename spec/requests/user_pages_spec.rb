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
    end
  end
end

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

  describe 'authorization' do

    describe 'for non-logged-in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_registration_path
          fill_in 'Login',    with: user.email
          fill_in 'Password', with: user.password
          click_button 'Login'
        end

        describe 'after loggin in' do
          it 'should render the desired protected page' do
            expect(page).to have_title(user.username)
          end
        end
      end

      describe 'in the Users controller' do

        describe 'visiting the edit page' do
          before { visit edit_user_registration_path }
          it { should have_title('Login') }
        end

        describe 'submitting to the update action' do
          #before { post user_path(user) }
          #specify { expect(response).to redirect_to(login_path) }
        end
      end
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { login user }

      describe 'visiting users/edit page' do
        #before { visit edit_user_path(wrong_user) }
        #it { should_not have_title('Edit')}
      end

      describe 'submitting a PATCH request to Users#update action' do
        #before { patch user_path(wrong_user) }
        #specify { expect(response).to redirect_to(root_path) }
      end
    end



  end
end
require 'spec_helper'

describe "Pages" do

  let(:base_title) { 'Healthy News' }

  subject { page }

  describe "Index page" do
    before { visit root_path }

    it { should have_title(full_title('')) }
    it { should have_content('Healthy News') }
    it { should_not have_title('- Home') }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_title(full_title('About')) }
    it { should have_content('About') }
  end
end
require 'spec_helper'

describe "Pages" do

  let(:base_title) { 'Healthy News' }

  describe "Index page" do

    it "should have the right title" do
      visit pages_index_path
      expect(page).to have_title("#{base_title}")
    end

    it "should have the content 'Healthy News'" do
      visit pages_index_path
      page.should have_content('Healthy News')
    end

    it "should not have a custom page title" do
      visit pages_index_path
      expect(page).not_to have_title('- Home')
    end
  end

  describe "About page" do
    it "should have the right title" do
      visit pages_about_path
      expect(page).to have_title("#{base_title} - About")
    end

    it "should have the content 'About'" do
      visit pages_about_path
      page.should have_content('About')
    end
  end
end
require 'spec_helper'

describe "Pages" do

  let(:base_title) { 'Healthy News' }

  subject { page }

  shared_examples_for "all pages" do
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Index page" do
    before { visit root_path }
    let(:heading) { 'Healthy News' }
    let(:page_title) { '' }

    it_should_behave_like 'all pages'
    it { should_not have_title('- Home') }
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About' }
    let(:page_title) { 'About' }


    it_should_behave_like 'all pages'
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link 'Register'
    expect(page).to have_title(full_title('Register'))
  end
end
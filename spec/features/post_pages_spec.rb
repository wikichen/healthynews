require 'spec_helper'

describe 'Post pages' do

  subject { page }

  describe 'index' do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      visit posts_path
    end

    it { should have_title('Healthy News') }

    describe 'pagination' do

      before(:all) { 30.times { FactoryGirl.create(:post, :user_id => user.id) } }
      after(:all)  { Post.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each post" do
        Post.paginate(page: 1).each do |post|
          expect(page).to have_selector('div.post-metadata',
                                        text: post.user.username)
        end
      end
    end
  end
end

require 'spec_helper'

describe User do

  before { @user = User.new(username: "exampleuser",
                            email: "user@example.com",
                            password: "examplepassword") }

  subject { @user }

  it { should respond_to(:username) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe "when username is not present" do
    before { @user.username = ' ' }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe "when email is too long" do
    before { @user.username = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "when username is already taken" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.username = @user.username.upcase
      user_with_same_username.save
    end

    it { should_not be_valid }
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "username with mixed case" do
    let(:mixed_case_username) { "h4rRyP0TT3r" }

    it "should be saved as all lowercase" do
      @user.username = mixed_case_username
      @user.save
      expect(@user.reload.username).to eq mixed_case_username.downcase
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lowercase" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

end
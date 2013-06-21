FactoryGirl.define do
  factory :user do
    username     "Jonathan Chen"
    email    "misc@chen.io"
    password "foobarfoobar"
    password_confirmation "foobarfoobar"
  end
end
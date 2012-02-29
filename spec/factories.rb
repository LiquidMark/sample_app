FactoryGirl.define do
  factory :user do
    name     "Mark Molloy"
    email    "mark.molloy@liquidautos.com"
    password "foobar"
    password_confirmation "foobar"
  end
end

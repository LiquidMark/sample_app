require 'spec_helper'

describe "Static pages:" do

  let(:site_name) {'Liquid Autos'}

  subject { page }

  describe "Home page:" do
    before { visit root_path } 
    it {should have_selector('h1', text: site_name)}
    it {should have_selector('title', text: full_title('Home'))}
    describe "for signed-in users:" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed:" do
        user.feed.each do |item|
          page.should have_selector("tr##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts:" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower",  href: followers_user_path(user)) }
      end

    end
  end

  describe "Help page:" do
    before { visit help_path } 
    it {should have_selector('h1', text: 'Help')}
    it {should have_selector('title', text: full_title('Help'))}
  end

  describe "About page:" do
    before { visit about_path } 
    it {should have_selector('h1', text: 'About')}
    it {should have_selector('title', text: full_title('About'))}
  end

  describe "Contact page:" do
    before { visit contact_path } 
    it {should have_selector('title', text: full_title('Contact'))}
    it {should have_selector('h1', text: "Contact #{site_name}")}
    it {should have_selector('body', text: "#{site_name} Contact Page.")}
  end

  it "should have the right links on the layout:" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('Home')
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end

end

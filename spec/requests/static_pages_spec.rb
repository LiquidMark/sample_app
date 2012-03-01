require 'spec_helper'

describe "Static pages" do

  let(:site_name) {'Liquid Autos'}

  subject { page }

  describe "Home page" do
    before { visit root_path } 
    it {should have_selector('h1', text: site_name)}
    it {should have_selector('title', text: full_title('Home'))}
  end

  describe "Help page" do
    before { visit help_path } 
    it {should have_selector('h1', text: 'Help')}
    it {should have_selector('title', text: full_title('Help'))}
  end

  describe "About page" do
    before { visit about_path } 
    it {should have_selector('h1', text: 'About')}
    it {should have_selector('title', text: full_title('About'))}
  end

  describe "Contact page" do
    before { visit contact_path } 
    it {should have_selector('title', text: full_title('Contact'))}
    it {should have_selector('h1', text: "Contact #{site_name}")}
    it {should have_selector('body', text: "#{site_name} Contact Page.")}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('Home')
    click_link "Sign Up Now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end

end

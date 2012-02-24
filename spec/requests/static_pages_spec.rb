require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Liquid Autos" }

  describe "Home page" do
    it "should have the h1 'Liquid Autos'" do
      visit root_path
      page.should have_selector('h1', :text => 'Liquid Autos')
    end
    it "should have the title 'Home'" do
      visit root_path
      page.should have_selector('title',
                        :text => "#{base_title} | Home")
    end
  end

  describe "Help page" do
    it "should have the h1 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end
    it "should have the title 'Help'" do
      visit help_path
      page.should have_selector('title',
                        :text => "#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should have the h1 'About'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Us')
    end
    it "should have the title 'About Us'" do
      visit about_path
      page.should have_selector('title',
                    :text => "#{base_title} | About Us")
    end
  end

  describe "Contact page" do
    it "should have the h1 'Contact Liquid Autos'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact Liquid Autos')
    end
    it "title should contain 'Contact Liquid Autos'" do
      visit contact_path
      page.should have_selector('title',
                    :text => "Contact Liquid Autos")
      page.should have_selector('body',
                    :text => "Liquid Autos Contact Page.")
    end
  end

end

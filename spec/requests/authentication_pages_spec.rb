require 'spec_helper'

describe "Authentication:" do

  subject { page }

  describe "authorization:" do

    describe "as non-admin user:" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action:" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
    
    describe "for non-signed-in users:" do
      let(:user) { Factory(:user) }

      describe "visiting user index:" do
        before { visit users_path }
        it { should have_selector('title', text: 'Sign in') }
      end

      describe "when attempting to visit a protected page:" do
        before do
          # Attempting to visit the edit user page throws us onto the
          # login page instead:
          visit edit_user_path(user)
          # So we log in:
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        describe "after signing in:" do
          # and after clicking Sign in, we should end up on the
          # edit user page, as requested prior to signin:
          it "should render the desired protected page:" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "in the Users controller:" do
        describe "visiting the edit page:" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action:" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the following page:" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the followers page:" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

      end

      describe "submitting to the create action:" do
        before { post microposts_path }
        specify { response.should redirect_to(signin_path) }

      end

      describe "submitting to the destroy action:" do
        before do
          micropost = FactoryGirl.create(:micropost)
          delete micropost_path(micropost)
        end
        specify { response.should redirect_to(signin_path) }

      describe "in the Relationships controller:" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action:" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end

      end

    end
    describe "as wrong user:" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page:" do
        before { visit edit_user_path(wrong_user) }
        # Trying to edit a user when not signed in as that user
        # redirects to the home page with a suitable diagnostic:
        it { should have_selector('title', text: 'Home') }
      end

      describe "submitting a PUT request to the Users#update action:" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

  describe "signin page:" do
    before { visit signin_path }
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    # This is a good place to check that links which should appear
    # after the user has logged in do NOT appear before that:
    it { should_not have_link('Users') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }
  end

  describe "signin:" do
    before { visit signin_path }

    describe "with invalid information:" do
      before { click_button "Sign in" }
      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.flash.error', text: 'Invalid') }
      describe "after visiting another page:" do
			  before { click_link "Home" }
			  it { should_not have_selector('div.alert.alert-error') }
			end
    end

    describe "with valid information:" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in') }

      describe "followed by signout:" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should have_selector('div.flash.notice', text: 'Logged out') }        
      end

      describe "followed by visiting home page:" do
        before { click_link "Home" }
        it { should_not have_link('Sign up') }
      end

    end

  end

end
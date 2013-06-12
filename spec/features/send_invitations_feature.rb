require 'spec_helper'

feature "Sending inivitations" do
  before { visit user_session_path }

  describe "invitation with valid user data" do
    let(:admin_user) { 
      FactoryGirl.create(:user)
    }
    before do
      admin_user.add_role :admin
      fill_in "Email",    with: admin_user.email.upcase
      fill_in "Password", with: admin_user.password
      click_button "Sign in"
    end
    it "sends invitations" do
      click_link 'Admin'
      save_and_open_page
      And I click a link "send invitation"
      And I open the email with subject "Confirmation instructions"
      Then I should see "confirm your email address" in the email body
    end
  end
end
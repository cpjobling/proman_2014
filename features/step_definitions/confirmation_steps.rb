Given(/^an administrator has sent me an invitation$/) do
    steps %Q{
      Given I request an invitation with valid user data
      And I am logged in as an administrator
      When I visit the users page
      And I click a link "send invitation"
      And I sign out
    }
  end

Given(/^I confirm my account with valid data$/) do
  @user = User.where({email: "visitor@#{ENV['EMAIL_DOMAIN']}"}).first
  visit "/users/confirmation?confirmation_token=#{@user.confirmation_token}"
  fill_in 'Choose a Password', with: 'changeme'
  fill_in 'Password Confirmation', with: 'changeme'
  click_button 'Activate'
  page.should have_content "Your account was successfully confirmed."
end

Then(/^I should be logged in$/) do
  page.should have_content "You are now signed in."
end

Then(/^I should be able to edit my account$/) do
  click_link 'Edit account'
  page.should have_content "Edit User"
  find_field('Email').value.should == @user.email
end

Given(/^I confirm my account with invalid data$/) do
  @user = User.where({email: "visitor@#{ENV['EMAIL_DOMAIN']}"}).first
  visit "/users/confirmation?confirmation_token=#{@user.confirmation_token}"
  fill_in 'Choose a Password', with: 'changeme'
  fill_in 'Password Confirmation', with: 'changeme2'
  click_button 'Activate'
  page.should have_content "Password doesn't match confirmation"
end

Then(/^I should not be logged in$/) do
  page.should_not have_content "You are now signed in."
end

Then(/^I should not be able to edit my account$/) do
  page.should_not have_content "Edit account"
end
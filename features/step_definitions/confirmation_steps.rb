Given(/^an administrator has sent me an invitation$/) do
    steps %Q{
      Given I request an invitation with valid user data
      And I am logged in as an administrator
      When I visit the users page
      And I click a link "send invitation"
      And I sign out
    }
end

def name
  FactoryGirl.build(:name)
end

Given(/^I confirm my account with valid data$/) do
  goto_confirmation_page
  enter_name(name)
  enter_password('changeme',with_confirmation: true)
  click_button 'Activate'
  page.should have_content "Your account was successfully confirmed."
end

def goto_confirmation_page
  @user = User.where({email: "visitor@#{ENV['EMAIL_DOMAIN']}"}).first
  visit "/users/confirmation?confirmation_token=#{@user.confirmation_token}"
end

def enter_name(name)
  select  name.honorific,   from: 'Title'
  fill_in 'First name',     with: name.first_name
  fill_in 'Last name',      with: name.last_name
  fill_in 'Other names',    with: name.other_names
  fill_in 'Preferred name', with: name.preferred_name
end

def enter_password(password,options)
  fill_in 'user_password', with: password
  if options[:with_confirmation]
    fill_in 'user_password_confirmation', with: password
  end
  if options[:confirmation]
    fill_in 'user_password_confirmation', with: options[:confirmation]
  end
end

Then(/^I should be logged in$/) do
  page.should have_content "You are now signed in."
end

Then(/^I should be able to edit my account$/) do
  click_link 'Edit account'
  page.should have_content "Edit Account"
  page.should have_content @user.email
end

Then(/^I should not be logged in$/) do
  page.should_not have_content "You are now signed in."
end

Then(/^I should not be able to edit my account$/) do
  page.should_not have_content "Edit Account"
end

Then(/^I should see that my name is "(.*?)"$/) do |message|
  page.should have_content message
end

Given(/^I confirm my account with an invalid name$/) do
  goto_confirmation_page
  pending "Password confirmations"
end

Given(/^I provide valid name data$/) do
  goto_confirmation_page
  enter_name(name)
end

Given(/^I confirm my account with credentials "(.*?)" and "(.*?)"$/) do |password, password_confirmation|
  enter_password password, confirmation: password_confirmation
  click_button 'Activate'
end

Then(/^I should see that my credentials are "(.*?)"$/) do |message|
  page.should have_content message
end

Given(/^I provide valid password data$/) do
  goto_confirmation_page
  enter_password 'password', with_confirmation: true
end

Given(/^I provide name data: "(.*?)" "(.*?)" "(.*?)" "(.*?)" "(.*?)"$/) do |title, first_name, last_name, other_names, preferred_name|
  the_name = FactoryGirl.build(:name, honorific: title, first_name: first_name, last_name: last_name, other_names: other_names, preferred_name: preferred_name)
  enter_name the_name
  click_button 'Activate'
end
Feature: Confirmation
  In order to create an account on the system
  As a user
  I should be able to confirm my account and set a password

  Scenario: User confirms account with valid data
    Given an administrator has sent me an invitation
    And I confirm my account with valid data
    Then I should be logged in
    And I should be able to edit my account

  Scenario: User confirms account with invalid data
    Given an administrator has sent me an invitation
    And I confirm my account with invalid data
    Then I should not be logged in
    And I should not be able to edit my account
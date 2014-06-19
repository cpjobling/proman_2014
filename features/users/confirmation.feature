Feature: Confirmation
  In order to create an account on the system
  As a user
  I should be able to confirm my account and set my name and password

  Scenario: User confirms account with valid data
    Given an administrator has sent me an invitation
    And I confirm my account with valid data
    Then I should be logged in
    And I should be able to edit my account

  Scenario Outline: Password validation
    Given an administrator has sent me an invitation
    And I provide valid name data
    And I confirm my account with credentials "<Password>" and "<Password Confirmation>"
    Then I should see that my credentials are "<Valid or Invalid>"
    And I should not be logged in
    And I should not be able to edit my account

    Examples: Blank
      Passwords must be present

      | Password | Password Confirmation | Valid or Invalid                    |
      |          | password              | Password can't be blank             |
      | password |                       | Password doesn't match confirmation |
      |          |                       | Password can't be blank             |

    Examples: Too short
      Passwords are invalid if less than 8 characters

      | Password | Password Confirmation | Valid or Invalid                     |
      | 1234567  | 1234567               | Password is too short                |
      | 1234567  | 1234568               | Password doesn't match confirmation  |

    Examples: Password and confirmation don't match
      Password confirmation must match password

      | Password | Password Confirmation | Valid or Invalid                        |
      | 12345678 | 12345677              | Password doesn't match confirmation     |
      | 12345678 |                       | Password doesn't match confirmation     |

  Scenario Outline: User confirms account with invalid name
    Given an administrator has sent me an invitation
    And I provide valid password data
    And I provide name data: "<Title>" "<First name>" "<Last name>" "<Other names>" "<Preferred name>"
    Then I should see that my name is "<Valid or Invalid>"
    Then I should not be logged in
    And I should not be able to edit my account

    Examples: Title blank
      Title is required
      | Title | First name | Last name | Other names | Preferred name | Valid or Invalid |
      |       |            | Aldrin    | Eugine      | Buzz           | invalid          |
      |       | Edwin      |           | Eugine      | Buzz           | invalid          |
      |       | Edwin      | Aldrin    |             | Buzz           | invalid          |
      |       | Edwin      | Aldrin    | Eugine      |                | invalid          |
      |       | Edwin      | Aldrin    | Eugine      | Buzz           | invalid          |
      |       | Edwin      | Aldrin    |             |                | invalid          |

    Examples: First name blank
      First name is required

      | Title | First name | Last name | Other names | Preferred name | Valid or Invalid |
      | Dr    |            | Aldrin    | Eugine      | Buzz           | invalid          |
      | Dr    |            |           | Eugine      | Buzz           | invalid          |
      | Dr    |            | Aldrin    |             | Buzz           | invalid          |
      | Dr    |            | Aldrin    | Eugine      |                | invalid          |
      | Dr    |            | Aldrin    |             |                | invalid          |


    Examples: Last name blank
      Last name is required

      | Title | First name | Last name | Other names | Preferred name | Valid or Invalid |
      | Dr    | Edwin      |           | Eugine      | Buzz           | invalid          |
      | Dr    | Edwin      |           |             | Buzz           | invalid          |
      | Dr    | Edwin      |           | Eugine      |                | invalid          |
      | Dr    | Edwin      |           |             |                | invalid          |
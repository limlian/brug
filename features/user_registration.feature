Feature: new user registration
  In order to use services from brug
  As a new guy for brug
  I want to register as a brug user	 

  Scenario: register with a non-existed username
    Given there is no existed user with email "demo@example.com"
    When I visit "/users/new"
    And I fill in "demo@example.com" registration information
    And I press "Register"
    Then there is existed user with email "demo@example.com"
    And I should navigate to page "login/index"
    And I should see "Registration successed"
 
  Scenario: register with an existed username
    Given there is already existed user with email "demo@example.com"
    When I visit "/users/new"
    And I fill in "demo@example.com" registration information
    And I press "Register"
    Then I should navigate to page "users/new"
    And I should see "Registration failed"
    And I should see "Email has been used"
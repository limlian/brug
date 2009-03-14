Feature: friends management
  In order to keep in touch with my friends
  As a brug user
  I want to manage friends contacts in brug
  
  Scenario: Add friend
  Given there is no user in the system
  And add a new user "demo1@example.com"
  And add a new user "demo2@example.com"
  And "demo1@example.com" has no friends
  When I log in as "demo1@example.com"
  And I visit "demo1@example.com" user page
  Then I should not see user "demo2@example.com" in the "friends-list"

  When I log in as "demo1@example.com"
  And I visit "demo2@example.com" user page
  And I press "Add as friend"
  And I visit "demo1@example.com" user page
  Then I should not see user "demo2@example.com" in the "friends-list"

  When I log in as "demo2@example.com"
  And I visit "demo2@example.com" message page
  Then I should see friend request from "demo1@example.com"

  When I log in as "demo2@example.com"
  And I visit "demo2@example.com" message page
  And I press "Accept"
  And I visit "demo2@example.com" user page
  Then I should see user "demo1@example.com" in the "friends-list"  
  
  When I log in as "demo1@example.com"
  And I visit "demo1@example.com" user page
  Then I should see user "demo2@example.com" in the "friends-list"  
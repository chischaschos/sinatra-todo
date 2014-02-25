Feature: A user can create a TODO list
  As an anonymous user
  I want to create a TODO list
  So I can manage my TODO items

  Scenario: The user signs up
    Given I go to the home page
    When I submit the sign up form
    Then I should see the TODO dashboard

  Scenario: The user creates a TODO list
    Given I already have an account
    And I go to the sign in page
    When I submit the sign in form
    Then I should see the TODO dashboard
    When I add the "buy milk" item
    And I add the "buy beer" item
    And I add the "get new clothes" item
    Then I should only see these items:
      |description|
      |buy milk|
      |buy beer|
      |get new clothes|
    And I can delete the "buy milk"
    And I add the "buy beans" item
    And I edit the "buy beer" to "buy a lot of beer"
    And I mark as completed "buy a lot of beer"
    Then I should only see these items:
      |description|
      |buy beans|
      |buy a lot of beer|
      |get new clothes|

  Scenario: I can sort items by due date

  Scenario: I can sort items by priority

  Scenario: The server is down and the user can not sign up/ sign in

  Scenario: The user fills in an empty email and/or password and can not sign in

  Scenario: The user fills in an empty email and/or password and can not sign up



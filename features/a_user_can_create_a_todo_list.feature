Feature: A user can create a todo list
  As an anonymous user
  I want to create a todo list
  So I can manage my todo items

  Scenario: The server is down and the user can not sign up/ sign in

  Scenario: The user fills in an empty email and/or password and can not sign in

  Scenario: The user fills in an empty email and/or password and can not sign up

  Scenario: The user signs in

  Scenario: The user signs up

  Scenario: The user creates a todo list
    Given I go to the home page
    And I create a list
    And I add the "buy milk" item
    And I add the "buy beer" item
    And I add the "get new clothes" item
   When I go to manage my list
   Then I can delete the "buy milk item"
   And I can add the "buy beans" item
   And I can edit the "buy beer" to "buy a lot of beer"

Feature: purchase book 
  As a book buyer, I would like to buy a book.
  
  Scenario: add book to cart
    Given my cart is empty
    When I add to my cart Pragmatic Version Control
    Then the cart is displayed
    And the order total is $29.95
  
  Scenario: add another book to cart
    Given my cart is empty 
    When I add to my cart Pragmatic Project Automation
    Then the cart is displayed 
    And the order total is $29.95

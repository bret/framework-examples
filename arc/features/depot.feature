Feature: Adding Product
  In order to sell books
  As a bookseller,
  I want to add books to the catalog

  Scenario: Add a Book to the Catalog
    Given I have logged as an admin
    When I add product "The Tycoons" as specified in testdata.ods
    Then I can order one copy of "The Tycoons"
    And my total will be $16.00


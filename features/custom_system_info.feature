# Copyright (c) 2011 Novell, Inc.
# Licensed under the terms of the MIT license.

Feature: Test custom system info key value pairs
  In Order to test the functionality of custom system infos
  As an authorized user
  I want to create and delete custom system info key value pairs
  
  Background:
    Given I am on the Systems page

  Scenario: Create a new key
    When I follow "Custom System Info" in the left menu
     And I should see a "No Custom Info Keys Found" text
     And I follow "create new key"
     And I should see a "Create Custom Info Key" text
     And I enter "key-label" as "label"
     And I enter "key-desc" as "description"
     And I click on "Create Key"
    Then I should see a "Successfully added 1 custom key." text

  Scenario: Add a value to a system
    When I follow "Systems" in the left menu
     And I follow this client link
     And I follow "Custom Info"
     And I follow "create new value"
     And I follow "key-label"
     And I enter "key-value" as "value"
     And I click on "Update Key"
    Then I should see a "key-label" text
     And I should see a "key-value" text
     And I should see a "Edit this value" link

  Scenario: Edit the value
    When I follow this client link
     And I follow "Custom Info"
     And I follow "Edit this value"
     And I should see a "Edit Custom Info Key" text
     And I enter "key-value-edited" as "value"
     And I click on "Update Key"
    Then I should see a "key-label" text
     And I should see a "key-value-edited" text
     And I should see a "Edit this value" link

  Scenario: Edit the key description
    When I follow "Custom System Info" in the left menu
     And I follow "key-label"
     And I should see this client as link
     And I enter "key-desc-edited" as "description"
     And I click on "Update Key"
    Then I should see a "key-label" link
     And I should see a "key-desc-edited" text

  Scenario: Delete the value
    When I follow "Custom System Info" in the left menu
     And I follow "key-label"
     And I follow this client link
     And I follow "Custom Info"
     And I follow "Edit this value"
     And I follow "delete value"
     And I click on "Remove Value"
    Then I should see a "No custom information defined for this system." text

  Scenario: Delete the key
    When I follow "Custom System Info" in the left menu
     And I follow "key-label"
     And I follow "delete key"
     And I click on "Delete Key"
    Then I should see a "No Custom Info Keys Found" text

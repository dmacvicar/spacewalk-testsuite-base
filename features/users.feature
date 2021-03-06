# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

# feature/users.feature
@simple
Feature: Check users page/tab
  Validate users page accessibility

  Scenario: Check users page content
    Given I am on the Users page
      Then I should see a "Active Users" text
        And I should see a "create new user" link
        And I should see a "User List" link in the left menu
        And I should see a "Active" link in the left menu
        And I should see a "Deactivated" link in the left menu
        And I should see a "All" link in the left menu
        #And I should see a "admin" link in "td" "first-column "
        And I should see 3 "admin" links
        And I should see a "Download CSV" link

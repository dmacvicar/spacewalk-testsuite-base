# Copyright (c) 2010-2011 SUSE Linux Products GmbH.
# Licensed under the terms of the MIT license.

Feature: CVE Audit
  In Order to check if systems are patched against certain vulnerabilities
  As the testing user
  I want to see systems that need to be patched

Scenario: Feature should be accessible
  Given I am on the Audit page
    Then I should see a "CVE Audit" link in the left menu
     And I should see a "CVE Audit" text

Scenario: searching for a known CVE number
  Given I am on the Audit page
    And I enter "CVE-2012-3400" as "cveIdentifier"
    And I click on "Audit systems"
  Then I should see this client as a link
    And I should see a "Affected, patch available in an assigned channel" text in the "Patch status" column
    And I should see a "Install a new patch in this system" link
  Then I follow "Install a new patch in this system"
    And I should see a "Relevant Patches" text

Scenario: searching for an unknown CVE number
  Given I am on the Audit page
    And I enter "CVE-2012-2806" as "cveIdentifier"
    And I click on "Audit systems"
  Then I should see a "Patch status unknown" text in the "Patch status" column
    And I should see a "Unknown" text in the "Next Action" column

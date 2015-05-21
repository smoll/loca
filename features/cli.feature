Feature: Loca CLI
  * Repo URL: https://github.com/smoll/Spoon-Knife
  * Pull URL: https://github.com/octocat/Spoon-Knife/pull/4865
  * This PR contains a new file titled "newfile"

  Scenario: Freshly cloned repo
    Given I successfully run `rake install`
    And I successfully run `git clone https://github.com/smoll/Spoon-Knife spoony`
    And I cd to "spoony"
    When I run `loca https://github.com/octocat/Spoon-Knife/pull/4865`
    Then the output should contain "PULL_4865"
    And a file named "newfile" should exist

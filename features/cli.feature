Feature: Loca CLI
  * Repo URL: https://github.com/smoll/Spoon-Knife
  * Pull URL: https://github.com/octocat/Spoon-Knife/pull/4865
  * This PR contains a new file titled "newfile"
  * This repo is cloned in a Before block in env.rb

  Scenario: Check out then delete a Pull Request
    When I run `loca https://github.com/octocat/Spoon-Knife/pull/4865`
    Then the output should contain "PULL_4865"
    And a file named "newfile" should exist
    When I run `loca https://github.com/octocat/Spoon-Knife/pull/4865 -d`
    Then the output should contain "Deleted branch PULL_4865"
    And a file named "newfile" should not exist

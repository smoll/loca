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
    And the exit status should be 0

  Scenario: Check out same Pull Request 2x
    When I run `loca https://github.com/octocat/Spoon-Knife/pull/4865`
    And I run `loca https://github.com/octocat/Spoon-Knife/pull/4865`
    Then a file named "newfile" should exist
    And the exit status should be 0

  Scenario: Attempt to check out wrong repo and validate backtrace
    When I run `loca https://github.com/notausername/notevenarepo/pull/1 -b`
    Then the exit status should not be 0
    And the stderr should contain "loca/lib/loca/cli.rb:"

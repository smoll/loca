# Loca [![Build Status](https://travis-ci.org/smoll/loca.svg?branch=master)](https://travis-ci.org/smoll/loca) [![Test Coverage](https://codeclimate.com/github/smoll/loca/badges/coverage.svg)](https://codeclimate.com/github/smoll/loca) [![Code Climate](https://codeclimate.com/github/smoll/loca/badges/gpa.svg)](https://codeclimate.com/github/smoll/loca) [![Dependency Status](https://gemnasium.com/smoll/loca.svg)](https://gemnasium.com/smoll/loca)

Command-line utility for checking out GitHub Pull Requests locally

## Installation

Make it available on the command line by doing

    $ gem install loca

## Usage

1. Copy a GitHub Pull Request URL to your clipboard, i.e. https://github.com/octocat/Spoon-Knife/pull/4865
2. Navigate to the directory where you have that repo checked out
3. Check out the PR by running

 ```
 $ loca https://github.com/octocat/Spoon-Knife/pull/4865
 ```

4. When you are done testing, clean it up by pressing the up-arrow and appending a `-d` flag

 ```
 $ loca https://github.com/octocat/Spoon-Knife/pull/4865 -d
 ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/loca/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

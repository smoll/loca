# Loca

Command-line utility for checking out GitHub Pull Requests locally

## Installation

Make it available on the command line by doing

    $ gem install loca

## Usage

1. Copy a GitHub Pull Request URL to your clipboard, i.e. https://github.com/theorchard/orchard/pull/2433
2. Navigate to the directory where you have that repo checked out
3. Check out the PR by running

 ```
 $ loca c https://github.com/theorchard/orchard/pull/2433
 ```

4. When you are done testing, clean it up by pressing the up-arrow and appending a -d flag

 ```
 $ loca c https://github.com/theorchard/orchard/pull/2433 -d
 ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/loca/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

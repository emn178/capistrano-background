# capistrano-background

Run background process for capistrano.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-background', group: :development
gem 'terminate'
```

And then execute:

    bundle

Or install it yourself as:

    gem install capistrano-background

## Usage
Require in your Capfile
```Ruby
require 'capistrano/background'
```
Add your background processes.
```Ruby
set :background_processes, {
  :scheduler => {
    :execute => [:rake, 'scheduler'],
    :timeout => 60 # kill process after waiting this time (seconds)
  }
}
```
It will run `rake scheduler` in background when deploy. You can also use command:

    cap production background:start
    cap production background:stop
    cap production background:restart

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contact
The project's website is located at https://github.com/emn178/capistrano-background  
Author: emn178@gmail.com

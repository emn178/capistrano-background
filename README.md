# capistrano-background

Run background process for capistrano.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-background'
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
add_background_process({
  :id => :scheduler,
  :execute => [:rake, 'scheduler']
})
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
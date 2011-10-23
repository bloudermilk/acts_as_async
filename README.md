# ActsAsAsync

ActsAsAsync is an ActiveRecord extension that provides your models with
easy-to-use Resque helpers.


## Installation

Installing ActsAsAsync is as simple as adding it to your Gemfile:

    $ cat Gemfile
    ...
    gem "acts_as_async"
    ...


## Usage

ActsAsAsync aims to be as simple as possible to use. Including it in your model
is as easy as:

    class Post < ActiveRecord::Base
      acts_as_async
    end

### Basic usage

ActsAsAsync adds three methods to your class that you can use to async any other
method.

    post = Post.create(:body => "Wow, acts_as_async is neat!")

    # Self-destruct as soon as possible
    post.async(:destroy)

    # Self-destruct at this time tomorrow
    post.async_at(Time.now + 1.day, :destroy)

    # Self-destruct in 10 minutes
    post.async_in(10.minutes, :destroy)

If all goes well the above methods should be added to Resque, and executed at
around the time you wanted. Feel free to async class methods as well:

    Post.async(:destroy_all)
    Post.async_at(1.day.from_now, :destroy_all)
    Post.async_in(10.minutes, :destroy_all)

### Dynamic methods

Coming soon...


## Everything else...

ActsAsAsync is simply a thin layer on top of [Resque][resque] and 
[Resque-scheduler][resque_scheduler]. To learn how to configure your redis
connection, run workers, view the web interface, and more visit their home pages.

[resque]: https://github.com/defunkt/resque
[resque_scheduler]: https://github.com/bvandenbos/resque-scheduler


## Compatibility

ActsAsAsync is tested against Ruby 1.8.7, 1.9.2, 1.9.3, REE, Rubinius, and JRuby.

Adding better (read: any) test coverage is top priority at the moment, so expect
to see the builds failing for a while. Not because the gem is broken (hopefully)
, but because the tests haven't been implemented yet.

![Build Status](https://secure.travis-ci.org/bloudermilk/acts_as_async.png?branch=master&.png)

[Build History](http://travis-ci.org/mongoid/mongoid)


## License

ActsAsAsync is released under the MIT License. See the LICENSE file for more info.

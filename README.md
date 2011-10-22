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

### Setup

ActsAsAsync aims to be as simple as possible to use. Including it in your model
is as easy as:

    class Post < ActiveRecord::Base
      acts_as_async

      def self.author_lazy_post
        Post.create(:body => "Lorem ipsum " * 10)
      end

      def self_destruct
        destroy
      end
    end

### Basic usage

You can use any of the three `async` methods to enqueue the execution
of any methods on your class:

    post = Post.create(:body => "Wow, acts_as_async is neat!")

    # Enqueue the method right away
    post.async(:self_destruct)

    # Enqueue the method at a specific time
    post.async_at(1.day.from_now, :self_destruct)

    # Enqueue the method some time from now
    post.async_in(10.minutes, :self_destuct)

### Class methods

Feel free to async class methods as well:

    lunch_break = 2.hours.from_now
    Post.async_at(lunch_break, :author_lazy_post)

### Dynamic async methods

Coming soon...


## Everything else...

ActsAsAsync is simply a thin layer on top of [Resque][resque] and 
[Resque-scheduler][resque_scheduler]. To learn how to configure your redis
connection, run workers, view the web interface and more visit their home pages.

[resque]: https://github.com/defunkt/resque
[resque_scheduler]: https://github.com/bvandenbos/resque-scheduler


## Compatibility

ActsAsAsync is tested against Ruby 1.8.7, 1.9.2, 1.9.3, REE, Rubinius, and JRuby.

![Build Status](https://secure.travis-ci.org/bloudermilk/acts_as_async.png?branch=master&.png)

[Build History](http://travis-ci.org/mongoid/mongoid)


## License

ActsAsAsync is released under the MIT License. See the LICENSE file for more info.

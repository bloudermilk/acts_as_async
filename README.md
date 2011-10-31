# ActsAsAsync

ActsAsAsync is an ActiveRecord extension that provides your models with
easy-to-use Resque helpers.


## Installation

Installing ActsAsAsync is as simple as adding it to your Gemfile:

```
$ cat Gemfile
...
gem "acts_as_async"
...
```


## Usage

ActsAsAsync aims to be as simple as possible to use. Including it in your model
is as easy as:

```ruby
class Post < ActiveRecord::Base
  acts_as_async
end
```

### Basic usage

ActsAsAsync adds three instance methods to your model that you can use to async
any other instance method:

```ruby
post = Post.create(:body => "Wow, acts_as_async is neat!")

# Self-destruct as soon as possible
post.async(:destroy)

# Self-destruct at this time tomorrow
post.async_at(Time.now + 1.day, :destroy)

# Self-destruct in 10 minutes
post.async_in(10.minutes, :destroy)
```

It also adds three identical class methods:

```ruby
Post.async(:destroy_all)
Post.async_at(1.day.from_now, :destroy_all)
Post.async_in(10.minutes, :destroy_all)
```

### Dynamic methods

In addition to the helper methods above, ActsAsAsync supports dynamic methods
for any existing method on your model. For example:

```ruby
class Audiobook < ActiveRecord::Base
  acts_as_async

  def transcribe
	# Some long-running logic here
  end

  def read!
	# Computers like to read too!
  end

  def paint(color)
	# I don't know why you'd paint a book...
  end
end

book = Audiobook.first

# Transcribe the book as soon as possible
book.async_transcribe

# Read the book at this time tomorrow
book.async_read_at!(Time.now + 1.day)

# Paint the book blue in a couple years
book.async_paint_in(2.years, "blue")
```

### Additional notes

  * You can pass any number of additional arguments to async'd methods so long
    as they can be serialized into JSON
  * Adding acts_as_async to your Gemfile automatically loads both Resque and
    Resque-scheduler's rake tasks. This means you can use both 
    `$ rake resque:work` and `$ rake resque:scheduler` right out of the box.
  * By deafult, each model will add tasks to a queue named "default". You can
	pass the `:queue` option to `acts_as_async` to specify a different queue.
  * Dynamic methods support names with exclamation points but not question
    marks. This was a design decision to discourage misuse of the question mark
    in method names. If you absolutely must async a method with a question mark,
    just use one of the `async :method` helpers.


## Everything else...

ActsAsAsync is simply a thin layer on top of [Resque][resque] and 
[Resque-scheduler][resque_scheduler]. To learn how to configure your redis
connection, run workers, view the web interface, and more visit their home
pages.

[resque]: https://github.com/defunkt/resque
[resque_scheduler]: https://github.com/bvandenbos/resque-scheduler


## Compatibility

ActsAsAsync is tested against the following Rubies: MRI 1.8.7, MRI 1.9.2,
MRI 1.9.3, Rubinius 2.0, and JRuby.

![Build Status](https://secure.travis-ci.org/bloudermilk/acts_as_async.png?branch=master&.png)

[Build History](http://travis-ci.org/#!/bloudermilk/acts_as_async)


## License

ActsAsAsync is released under the MIT license. See the LICENSE file for more
info.

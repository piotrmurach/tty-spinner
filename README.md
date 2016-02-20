# TTY::Spinner
[![Gem Version](https://badge.fury.io/rb/tty-spinner.png)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty-spinner.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty-spinner.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty-spinner/badge.png)][coverage]

[gem]: http://badge.fury.io/rb/tty-spinner
[travis]: http://travis-ci.org/peter-murach/tty-spinner
[codeclimate]: https://codeclimate.com/github/peter-murach/tty-spinner
[coverage]: https://coveralls.io/r/peter-murach/tty-spinner

> A terminal spinner for tasks that have non-deterministic time frame.

**TTY::Spinner** provides independent spinner component for [TTY](https://github.com/peter-murach/tty) toolkit.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tty-spinner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tty-spinner

## Contents

* [1. Usage](#1-usage)
  * [1.1 spin](#11-spin)
  * [1.2 stop](#12-stop)
  * [1.3 reset](#13-reset)
* [2. Configuration](#2-configuration)
* [3. Formatting](#3-formatting)

## 1. Usage

**TTY::Spinner** by default uses `:spin_1` type of formatter and requires no paramters:

```ruby
spinner = TTY::Spinner.new
```

In addition you can provide a message and format type you would like for the spinning display like so:

```ruby
spinner = TTY::Spinner.new('Loading ... ', format: :spin_2)
30.times do
  spinner.spin
  sleep(0.1)
end
```

This would produce animation in your terminal:

```ruby
Loading ... ⎺
```

### 1.1 spin

The main workhorse of the spinner is the `spin` method. Looping over `spin` method will animate a given spinner.

### 1.2 stop

In order to stop the spinner call `stop`. This will finish drawing the spinning and return to new line.

```ruby
spinner.stop
```

You can further pass a stop message to print in place of spinning animation:

```ruby
spinner.stop('Done!')
```

which would produce for the above example the following:

```ruby
Loading ... Done!
```

### 1.3 reset

In order to reset the spinner to its initial frame do:

```ruby
spinner.reset
```

## 2. Configuration

There are number of configuration options that can be provided:

* `format` the formatting token (see [Formatting](#3-formatting))
* `output` the output stream defaulting to `stderr`
* `hide_cursor` to hide display cursor defaulting to `false`

## 3. Formatting

**TTY::Spinner** accepts `:spin_1` to `:spin_15` as spinner formats.

## Contributing

1. Fork it ( https://github.com/peter-murach/tty-spinner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014-2016 Piotr Murach. See LICENSE for further details.

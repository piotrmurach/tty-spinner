# TTY::Spinner
[![Gem Version](https://badge.fury.io/rb/tty-spinner.svg)][gem]
[![Build Status](https://secure.travis-ci.org/peter-murach/tty-spinner.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/peter-murach/tty-spinner/badges/gpa.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/peter-murach/tty-spinner/badge.svg)][coverage]
[![Inline docs](http://inch-ci.org/github/peter-murach/tty-spinner.svg?branch=master)][inchpages]

[gem]: http://badge.fury.io/rb/tty-spinner
[travis]: http://travis-ci.org/peter-murach/tty-spinner
[codeclimate]: https://codeclimate.com/github/peter-murach/tty-spinner
[coverage]: https://coveralls.io/r/peter-murach/tty-spinner
[inchpages]: http://inch-ci.org/github/peter-murach/tty-spinner

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
* [2. API](#2-api)
  * [1.1 spin](#21-spin)
  * [1.2 stop](#22-stop)
  * [1.3 reset](#23-reset)
* [3. Configuration](#3-configuration)
  * [3.1 :format](#31-format)
  * [3.2 :frames](#32-frames)
  * [3.2 :hide_cursor](#33-hide-cursor)
  * [3.4 :output](#34-output)

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

## 2. API

### 2.1 spin

The main workhorse of the spinner is the `spin` method. Looping over `spin` method will animate a given spinner.

### 2.2 stop

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

### 2.3 reset

In order to reset the spinner to its initial frame do:

```ruby
spinner.reset
```

## 3. Configuration

There are number of configuration options that can be provided to customise the behaviour of a spinner.

* `hide_cursor` to hide display cursor defaulting to `false`
* `color`

### 3.1 :format

Use one of the predefined spinner styles by passing the formatting token `:format`

```ruby
spinner = TTY::Spinner.new(format: :spin_1)
```

**TTY::Spinner** accepts `:spin_1` to `:spin_15` as spinner formats.

### 3.2 :frames

If you wish to use custom formatting use the `:frames` option with either `array` or `string` of characters.

```ruby
spinner = TTY::Spinner.new(frames: [".", "o", "0", "@", "*"])
```

### 3.3 :hide_cursor

Hides cursor when spinning animation performs. Defaults to `false`.

```ruby
spinner = TTY::Spinner.new(hide_cursor: true)
```

### 3.4 :output

To change where data is streamed use `:output` option like so:

```
spinner = TTY::Spinner.new(output: $stdout)
```

The output stream defaults to `stderr`.

## Contributing

1. Fork it ( https://github.com/peter-murach/tty-spinner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2014-2016 Piotr Murach. See LICENSE for further details.

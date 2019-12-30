# Minitest::Filesystem

[![Gem Version](https://badge.fury.io/rb/minitest-filesystem.svg)](http://badge.fury.io/rb/minitest-filesystem)
[![Build Status](https://travis-ci.org/stefanozanella/minitest-filesystem.svg?branch=master)](https://travis-ci.org/stefanozanella/minitest-filesystem)
[![Code Climate](https://codeclimate.com/github/stefanozanella/minitest-filesystem/badges/gpa.svg)](https://codeclimate.com/github/stefanozanella/minitest-filesystem)
[![Test Coverage](https://codeclimate.com/github/stefanozanella/minitest-filesystem/badges/coverage.svg)](https://codeclimate.com/github/stefanozanella/minitest-filesystem)

Adds assertions and expectations to check filesystem content in a communicative way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-filesystem'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install minitest-filesystem
```

Once the gem is installed, just add this line to your `test_helper.rb`:

```ruby
require 'minitest/filesystem'
```

## Usage

### Testing for a filesystem subtree
Let's suppose the following filesystem structure exists:

* `root_dir/`
  * `file_1`
  * `file_2`
  * `subdir_1/`
      * `subfile_1`
      * `subfile_2`
      * `subsubdir_1/`
  * `subdir_2/`
  * `subdir_3/`
      * `link_1`, `'...'`
      * `link_2`, `'../../file_1'`

You can check if `root_dir` contains a specific structure:

```ruby
assert_contains_filesystem("root_dir") do
  file "file_1"
  dir "subdir_1" do
    file "subfile_1"
  end
  dir "subdir_2"
  dir "subdir_3" do
    link "link_1"
  end
end
```

or, if you prefer the expectation style:

```ruby
filesystem {
  file "file_1"
  dir "subdir_1" do
    file "subfile_1"
  end
  dir "subdir_2"
  dir "subdir_3" do
    link "link_1"
  end
}.must_exist_within "root_dir"
```

Note that the match **need not to be exact** (i.e. there can be other files and
directories inside `root_dir` that the matcher won't care about).

### Syntactic sugar

As a nicety, some custom assertions/matchers are provided to make your test
suites look better. They're almost just syntactic sugar around the methods
provided by `File`, `Dir` et al, but allow for improved code readability. So,
for example, instead of writing

```ruby
assert File.exists? "/a/file"
```

you can write

```ruby
assert_exists "/a/file"
```

or, even better

```ruby
"/a/file".must_exist
```

**Assertions**

* `assert_exists`: test whether a specific path exists (no matter if file, dir, symlink)
* `refute_exists`: test whether a specific path doesn't exist (no matter if file, dir, symlink)

**Expectations**

The meaning of the following expectation is the same as their assertive counterpart:

* `must_exist`
* `wont_exist`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


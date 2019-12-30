require "minitest/filesystem/version"
require "minitest/filesystem/matcher"

module Minitest::Assertions
  def assert_contains_filesystem(dir, msg = nil, &block)
    matcher = Minitest::Filesystem::Matcher.new(dir, &block)
    assert matcher.match_found?, msg || matcher.message
  end

  def assert_exists(path, msg = nil, &block)
    assert File.exist?(path), msg || "expected `#{path}` to exist, but it doesn't"
  end

  def refute_exists(path, msg = nil, &block)
    refute File.exist?(path), msg || "expected `#{path}` not to exist, but it does"
  end

  def filesystem(&block)
    block
  end
end


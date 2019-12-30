require "minitest/filesystem/version"
require "minitest/filesystem/matcher"
require "minitest/filesystem/matching_tree"

module Minitest::Assertions
  # @return [void]
  def assert_contains_filesystem(dir, msg = nil, &block)
    matcher = Minitest::Filesystem::Matcher.new(dir, &block)
    assert(matcher.match_found?, msg || matcher.message)
  end

  # @return [void]
  def assert_exists(path, msg = nil, &block)
    msg ||= "expected `#{path}` to exist, but it doesn't"
    assert(File.exist?(path), msg)
  end

  # @return [void]
  def refute_exists(path, msg = nil, &block)
    msg ||= "expected `#{path}` not to exist, but it does"
    refute(File.exist?(path), msg)
  end

  # @return [void]
  def filesystem(&block)
    block
  end
end


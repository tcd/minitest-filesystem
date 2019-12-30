require "test_helper"

class AssertExistsTest < Minitest::Test
  def setup
    @root_dir = Pathname.new(Dir.mktmpdir("minitestfs"))
    @a_path   = @root_dir + "a_file"
  end

  def test_that_it_fails_when_the_given_path_is_not_found
    l = -> { assert_exists(@a_path) }
    error = assert_raises(Minitest::Assertion, &l)
    assert_match("expected '#{@a_path}' to exist", error.message)
  end

  def test_that_it_allows_printing_of_custom_error_messages
    failure_msg = "I really miss this path a lot"
    l = -> { assert_exists(@a_path, failure_msg) }
    error = assert_raises(Minitest::Assertion, &l)
    assert_equal(failure_msg, error.message)
  end
end

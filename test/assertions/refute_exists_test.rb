require "test_helper"

class RefuteExistsTest < Minitest::Test
  def setup
    @root_dir = Pathname.new(Dir.mktmpdir("minitestfs"))
  end

  def test_that_it_fails_when_the_given_path_is_found
    error = assert_raises(Minitest::Assertion) do
      refute_exists(@root_dir)
    end
    assert_match(/expected `#{@root_dir}` not to exist/im, error.message)
  end
end

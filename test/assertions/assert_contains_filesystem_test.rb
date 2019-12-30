require "test_helper"

class AssertContainsFilesystemTest < Minitest::Test
  def setup
    @root_dir = Pathname.new(Dir.mktmpdir("minitestfs"))

    (@root_dir + "a_directory").mkdir
    (@root_dir + "a_subdirectory").mkdir
    (@root_dir + "a_subdirectory" + "deeper_subdirectory").mkdir
    (@root_dir + "not_a_file").mkdir
    (@root_dir + "unchecked_dir").mkdir

    FileUtils.touch(@root_dir + "a_file")
    FileUtils.touch(@root_dir + "actual_file")
    FileUtils.ln_s( @root_dir + "doesnt_matter", @root_dir + "a_link")
    FileUtils.ln_s( @root_dir + "actual_file", @root_dir + "link_to")
    FileUtils.touch(@root_dir + "not_a_dir")
    FileUtils.touch(@root_dir + "not_a_link")
    FileUtils.touch(@root_dir + "a_subdirectory" + "deeper_subdirectory" + "another_file")
    FileUtils.touch(@root_dir + "unchecked_file")
  end

  def teardown
    FileUtils.rm_rf(@root_dir)
  end

  def test_passes_with_empty_expected_tree
    assert_contains_filesystem(@root_dir) {}
  end

  def test_passes_when_single_file_found
    assert_contains_filesystem(@root_dir) do
      file "a_file"
    end
  end

  def test_passes_when_single_link_found
    assert_contains_filesystem(@root_dir) do
      link "a_link"
    end
  end

  def test_passes_when_a_link_points_to_the_correct_target
    assert_contains_filesystem(@root_dir) do
      link "link_to", "actual_file"
    end
  end

  def test_passes_when_single_directory_found
    assert_contains_filesystem(@root_dir) do
      dir "a_directory"
    end
  end

  def test_passes_when_a_file_within_a_nested_subtree_is_found
    assert_contains_filesystem(@root_dir) do
      dir "a_subdirectory" do
        dir "deeper_subdirectory" do
          file "another_file"
        end
      end
    end
  end

  def test_fails_when_an_expected_file_isnt_found
    l = lambda { assert_contains_filesystem(@root_dir) { file "foo" } }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected '#{@root_dir}' to contain file 'foo'/im, error.message)
  end

  def test_fails_when_an_expected_symlink_isnt_found
    l = lambda { assert_contains_filesystem(@root_dir) do
      link "foo"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected '#{@root_dir}' to contain symlink 'foo'/im, error.message)
  end

  def test_fails_when_a_symlink_points_to_the_wrong_file
    l = lambda { assert_contains_filesystem(@root_dir) do
      link "link_to", "nonexistent_target"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected 'link_to' to point to 'nonexistent_target'/im, error.message)
  end

  def test_fails_when_an_expected_directory_isnt_found
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "bar"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected '#{@root_dir}' to contain directory 'bar'/im, error.message)
  end

  def test_fails_when_an_expected_file_within_a_subdirectory_isnt_found
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "a_subdirectory" do
        file "missing_file"
      end
    end }

    error = assert_raises(Minitest::Assertion, &l)
      assert_match(/expected '#{@root_dir + 'a_subdirectory'}' to contain file 'missing_file'/im, error.message)
  end

  def test_fails_when_a_directory_is_expected_to_be_a_file
    l = lambda { assert_contains_filesystem(@root_dir) do
      file "not_a_file"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected 'not_a_file' to be a file/im, error.message)
  end

  def test_fails_when_a_file_is_expected_to_be_a_directory
    l = lambda { assert_contains_filesystem(@root_dir) do
      dir "not_a_dir"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected 'not_a_dir' to be a directory/im, error.message)
  end

  def test_fails_when_a_file_is_expected_to_be_a_symlink
    l = lambda { assert_contains_filesystem(@root_dir) do
      link "not_a_link"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_match(/expected 'not_a_link' to be a symlink/im, error.message)
  end

  def test_allows_to_print_custom_error_messages
    failure_msg = "I really miss this file a lot"

    l = lambda { assert_contains_filesystem(@root_dir, failure_msg) do
      file "baz"
    end }

    error = assert_raises(Minitest::Assertion, &l)
    assert_equal(failure_msg, error.message)
  end

end

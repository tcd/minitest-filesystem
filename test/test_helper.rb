require "simplecov"
formatters = []
formatters << SimpleCov::Formatter::HTMLFormatter
if ENV["CI"] == "true"
  require "coveralls"
  formatters << Coveralls::SimpleCov::Formatter
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(formatters)

SimpleCov.start do
  add_filter "/bin/"
  add_filter "/test/"

  track_files "lib/**/*.rb"
end

require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
Minitest::Reporters.use!([
  Minitest::Reporters::DefaultReporter.new(color: true),
  # Minitest::Reporters::SpecReporter.new,
])

require "minitest/filesystem"

require "tmpdir"
require "fileutils"

# alias for `FileUtils.touch(path)`
def touch(path)
  FileUtils.touch(path)
end

# alias for `FileUtils.rm_rf(path)`
def rm(path)
  FileUtils.rm_rf(path)
end

# alias for `FileUtils.rm_rf(path)`
def symlink(path, link)
  FileUtils.ln_s(path, link)
end

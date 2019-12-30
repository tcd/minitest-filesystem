require "pathname"

module Minitest
  module Filesystem
    class MatchingTree

      # @return [Pathname]
      attr_reader :root

      # @return [void]
      def initialize(root)
        @root = Pathname.new(root)
        @tree = expand_tree_under @root
      end

      # @return [Boolean]
      def include?(entry)
        @tree.include?(expand_path(entry))
      end

      # @return [Boolean]
      def is_a?(entry, kind)
        (expand_path entry).send("#{kind}?")
      end

      # @return [Boolean]
      def has_target?(entry, target)
        expand_path(target) == follow_link(entry)
      end

      # @return [Pathname]
      def expand_path(file)
        @root + Pathname.new(file)
      end

      # @return [Pathname]
      def follow_link(link)
        Pathname.new(File.readlink(expand_path(link)))
      end

      private

      # @return [Array<Pathname>]
      def expand_tree_under(dir)
        Pathname.glob(dir.join("**/*"))
      end

    end
  end
end

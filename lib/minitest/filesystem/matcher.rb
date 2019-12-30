require "pathname"

module Minitest
  module Filesystem
    class Matcher

      # @return [void]
      def initialize(root, &block)
        # @type [MatchingTree]
        @actual_tree = MatchingTree.new(root)
        # @type [&block]
        @expected_tree = block
        # @type [Boolean]
        @is_matching = true
      end

      # @return [Boolean]
      def file(file)
        exists?(file, :file)
      end

      # @return [Boolean]
      def link(link, target = nil)
        exists?(link, :symlink) && is_target_correct?(link, target)
      end

      # @return [Boolean]
      def dir(dir, &block)
        matcher = self.class.new(@actual_tree.expand_path(dir), &block) if block_given?

        exists?(dir, :directory) && subtree(matcher)
      end

      # @return [Boolean]
      def match_found?
        instance_eval(&@expected_tree)
        @is_matching
      end

      # @return [String]
      def message
        @failure_msg || ""
      end

      private

      # Checks existance of specified entry.
      # Existance is defined both in terms of presence and of being of the
      # right type (e.g. a file being a file and not a directory)
      #
      # @return [Boolean]
      def exists?(entry, kind = :entry)
        entry(entry, kind) && is_a?(entry, kind)
      end

      # Checks if an entry with given name exists.
      #
      # @return [Boolean]
      def entry(entry, kind = :entry)
        update_matching_status(
          @actual_tree.include?(entry),
          not_found_msg_for(entry, kind),
        )
      end

      # Checks if a specific entry (supposed to exist) is of a given kind.
      # @return [Boolean]
      def is_a?(entry, kind)
        update_matching_status(
          @actual_tree.is_a?(entry, kind),
          mismatch_msg_for(entry, kind),
        )
      end

      # Checks the target of a symbolic link.
      #
      # @return [Boolean]
      def is_target_correct?(link, target)
        return true unless target

        update_matching_status(
          @actual_tree.has_target?(link, target),
          link_target_mismatch_msg_for(link, target),
        )
      end

      # @return [Boolean,nil]
      def subtree(matcher)
        update_matching_status(matcher.match_found?, matcher.message) if matcher
      end

      # @return [Boolean]
      def update_matching_status(check, msg)
        @is_matching = @is_matching && check
        set_failure_msg(msg) unless @is_matching

        @is_matching
      end

      # @return [String]
      def not_found_msg_for(entry, kind)
        "Expected `#{@actual_tree.root}` to contain #{kind} `#{entry}`."
      end

      # @return [String]
      def mismatch_msg_for(entry, kind)
        "Expected `#{entry}` to be a #{kind}, but it was not."
      end

      # @return [String]
      def link_target_mismatch_msg_for(link, target)
        "Expected `#{link}` to point to `#{target}`, but it pointed to #{@actual_tree.follow_link(link)}"
      end

      # @return [void]
      def set_failure_msg(msg)
        @failure_msg ||= msg
      end

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
end

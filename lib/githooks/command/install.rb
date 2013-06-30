require 'githooks/command'

module Githooks
  module Command
    # Installs the given hook in the local repository. If there is no local
    # hook by the given name, delegates to the the Fetch command to get the
    # hook first.
    #
    class Install < Common
      def call
        hook_name    = args.first
        local_source = Source::Local.new(config.hook_path(hook_name))

        if not local_source.exists?
          Fetch.call(args)
        end

        hook = Hook.new(local_source)

        prepare_git_hook(hook)
        install_git_hook(hook)
      end

      def prepare_git_hook(hook)
        validate_git_repo

        hook_type = hook.metadata.type
        validate_hook_type(hook_type)

        git_hook_file = ".git/hooks/#{hook_type}"

        if not File.exists?(git_hook_file)
          File.open(git_hook_file, 'w') do |f|
            f.puts '#! /bin/sh'
            f.puts ''
          end
          File.chmod(0755, git_hook_file)
        end
      end

      def install_git_hook(hook)
        hook_type       = hook.metadata.type
        git_hook_file   = ".git/hooks/#{hook_type}"
        hook_invocation = "githooks run #{hook.name} $*"

        lines         = File.readlines(git_hook_file).map(&:rstrip)
        existing_hook = lines.find { |l| l.include?(hook_invocation) }

        if existing_hook
          say "Hook already installed"
          return
        end

        say "Installing hook #{hook}"
        end_line_index = lines.rindex { |l| l =~ /^# End of githooks scripts/ }

        if end_line_index
          lines.insert(end_line_index, hook_invocation)
        else
          lines << '# Start of githooks scripts'
          lines << hook_invocation
          lines << '# End of githooks scripts'
        end

        File.open(git_hook_file, 'w') do |f|
          f.write(lines.join("\n"))
        end
      end

      def validate_git_repo
        if not File.directory?('.git/hooks')
          error "Can't find `.git/hooks` directory, are you in a git repository?"
        end
      end

      # TODO (2013-06-30) Move validations to Metadata?
      def validate_hook_type(type)
        if not possible_hook_types.include?(type)
          error "The type of the script needs to be one of: #{possible_hook_types.join(', ')}."
        end
      end
    end
  end
end

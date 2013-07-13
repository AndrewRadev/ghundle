require 'githooks/command'

module Githooks
  module Command
    # Installs the given hook in the local repository. If there is no local
    # hook by the given name, delegates to the the Fetch command to get the
    # hook first.
    #
    class Install < Common
      def call
        args.each do |hook_name|
          local_source = Source::Local.new(config.hook_path(hook_name))

          if not local_source.exists?
            # try to fetch it instead
            Fetch.call(*args)
            real_hook_name = File.basename(hook_name)
            local_source   = Source::Local.new(config.hook_path(real_hook_name))
          end

          hook = Hook.new(local_source)

          prepare_git_hook(hook)
          install_git_hook(hook)
        end
      end

      def prepare_git_hook(hook)
        validate_git_repo

        hook_types = hook.metadata.types
        hook_types.each do |hook_type|
          validate_hook_type(hook_type)
        end

        hook_types.each do |hook_type|
          git_hook_file = ".git/hooks/#{hook_type}"

          if not File.exists?(git_hook_file)
            File.open(git_hook_file, 'w') do |f|
              f.puts '#! /bin/sh'
              f.puts ''
            end
            File.chmod(0755, git_hook_file)
          end
        end
      end

      def install_git_hook(hook)
        hook.metadata.types.each do |hook_type|
          git_hook_file   = ".git/hooks/#{hook_type}"
          hook_invocation = "githooks run #{hook.name} $*"

          lines         = File.readlines(git_hook_file).map(&:rstrip)
          existing_hook = lines.find { |l| l.include?(hook_invocation) }

          if existing_hook
            say "Hook already installed for #{hook_type}"
            return
          end

          say "Installing hook #{hook} for #{hook_type}"
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
